package main

import (
	"context"
	"errors"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"github.com/aws/smithy-go"
)

func main() {
	lambda.Start(awsCostOptimize)
}

func awsCostOptimize() {
	configs, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("ap-south-1"))
	if err != nil {
		log.Fatalf("Erro authenticting AWS SDK")
	}

	client := ec2.NewFromConfig(configs)

	// get owner ID of caller AWS account
	stsClient := sts.NewFromConfig(configs)
	callerId, err := stsClient.GetCallerIdentity(context.TODO(), &sts.GetCallerIdentityInput{})
	if err != nil {
		fmt.Println("ERROR", err)
	}
	ownerID := *callerId.Account

	// get snapshots Volume ID
	snapshot, err := client.DescribeSnapshots(context.TODO(), &ec2.DescribeSnapshotsInput{
		OwnerIds: []string{ownerID},
	})
	if err != nil {
		fmt.Println("ERROR", err)
	}

	// check for stale snapshots: check for every snapshot's Volume ID, and check if exists
	for _, snap := range snapshot.Snapshots {
		snapID := *snap.SnapshotId
		volID := *snap.VolumeId

		_, err := client.DescribeVolumes(context.TODO(), &ec2.DescribeVolumesInput{
			VolumeIds: []string{volID},
		})
		if err != nil {
			var volErr smithy.APIError
			if errors.As(err, &volErr) {
				switch volErr.ErrorCode() {
				case "InvalidVolume.NotFound":
					fmt.Println("Deleted the %s stale snapshot", snapID)
					deleteStaleSnapshots(snapID, client)
				default:
					fmt.Printf("ERROR", volErr)
				}
			} else {
				fmt.Printf("Error in checking volume")
			}
		} else {
			fmt.Println("No stale snapshots available.")
		}

	}
}

func deleteStaleSnapshots(snapID string, client *ec2.Client) {
	output, err := client.DeleteSnapshot(context.TODO(), &ec2.DeleteSnapshotInput{
		SnapshotId: &snapID,
	})

	if err != nil {
		fmt.Println("ERROR", err)
	}
	fmt.Println(*output)
}
