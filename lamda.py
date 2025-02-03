import boto3
import json
import csv
import io
from datetime import datetime

ALLOWED_SERVICES = ["Data", "Processing", "Web"]
SNS_TOPIC_ARN = "SNS TOPIC ARN"  
S3_BUCKET = "BUCKET_NAME"  

sns = boto3.client('sns', region_name='ap-south-1')

def lambda_handler(event, context):
    # Check if function is running in test mode (no alerts sent if test_mode is True)
    test_mode = str(event.get("Test", "False")).lower() == "true"
    
    # Use a default region client (us-east-1) to get a list of all regions.
    ec2_default = boto3.client('ec2', region_name='us-east-1')
    regions_response = ec2_default.describe_regions()
    region_names = [r['RegionName'] for r in regions_response['Regions']]
    
    all_instances = []
    
    # Iterate over every region
    for region in region_names:
        ec2 = boto3.client('ec2', region_name=region)
        try:
            response = ec2.describe_instances()
        except Exception as e:
            print(f"Error describing instances in region {region}: {e}")
            continue
        
        for reservation in response.get('Reservations', []):
            
            for instance in reservation.get('Instances', []):
                state = instance.get("State", {}).get("Name")
                if state.lower() in ["running", "stopped"]:
                    tags = instance.get("Tags", [])
                    
                    # Check for the "Service" tag (case-insensitive)
                    tags_value = None
                    for tag in tags:
                        if tag.get("Key").lower() == "service":
                            tags_value = tag.get("Value")
                            break
                    
                    # If the "Service" tag is missing or its value is not allowed,
                    # and if not in test mode, generate an SNS alert.
                    if (tags_value is None) or (tags_value not in ALLOWED_SERVICES):
                        message = (
                            f"Alert: In region {region}, Instance {instance.get('InstanceId')} is {state} "
                            f"without a valid 'Service' tag. Found: '{tags_value}'. "
                            f"Allowed values: {', '.join(ALLOWED_SERVICES)}."
                        )
                        if not test_mode:
                            sns.publish(
                                TopicArn=SNS_TOPIC_ARN,
                                Message=message,
                                Subject="EC2 Instance Tag Alert"
                            )
                    
                    # Store instance details, including region information.
                    instance_info = {
                        "Region": region,
                        "InstanceId": instance.get("InstanceId"),
                        "Service": tags_value,
                        "InstanceClass": instance.get("InstanceType"),
                        "MachineImage": instance.get("ImageId"),
                        "State": state,
                        "Tags": tags
                    }
                    all_instances.append(instance_info)
    
    # Prepare CSV content with details from all regions
    csv_buffer = io.StringIO()
    csv_writer = csv.writer(csv_buffer)
    header = ["Region", "InstanceId", "Service", "InstanceClass", "MachineImage", "State", "Tags"]
    csv_writer.writerow(header)
    for instance in all_instances:
        # Convert tags to a string format "Key1=Value1;Key2=Value2"
        tag_str = ";".join([f"{tag.get('Key')}={tag.get('Value')}" for tag in instance.get("Tags", [])])
        csv_writer.writerow([
            instance.get("Region"),
            instance.get("InstanceId"),
            instance.get("Service"),
            instance.get("InstanceClass"),
            instance.get("MachineImage"),
            instance.get("State"),
            tag_str
        ])
    
    # Create a timestamped key for the CSV file
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    key = f"ec2_instances_{timestamp}.csv"
    
    # Upload CSV to S3 (using ap-south-1 region here)
    s3 = boto3.client('s3', region_name='ap-south-1')
    bucket = "buckey09"  # Replace with your S3 bucket name
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    key = f"ec2_instances_{timestamp}.csv"
    s3.put_object(
        Bucket=bucket,
        Key=key,
        Body=csv_buffer.getvalue(),
        ContentType='text/csv'
    )
    # (Optional) Return CSV content or location
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "CSV exported successfully and Process completed. Test mode: " + str(test_mode),
            "instances_count": len(all_instances),
            "s3_bucket": bucket,
            "s3_key": key
        })
    }


