import json

sample_cloudtrail = {
    "Records": [
    {
        "eventVersion": "1.0",
        "eventName": "CreateBucket",
        "eventTime": "2023-01-01T12:00:00Z",
        "userIdentity": {
            "type": "IAMUser",
            "userName": "alice",
            "accountId": "123456789012"
        },
        "requestParameters": {
            "bucketName": "my-new-bucket"
        }
    },
    {
        "eventVersion": "1.0",
        "eventName": "UpdateBucket",
        "eventTime": "2023-01-01T12:00:00Z",
        "userIdentity": {
            "type": "IAMUser",
            "userName": "alice",
            "accountId": "123456789012"
        },
        "requestParameters": {
            "bucketName": "my-new-bucket"
        }
    },
        {
            "eventVersion": "1.0",
            "eventName": "PutObject",
            "eventTime": "2023-01-01T12:05:00Z",
            "userIdentity": {
                "type": "IAMUser",
                "userName": "bob",
                "accountId": "123456789012"
            },
            "requestParameters": {
                "bucketName": "existing-bucket",
                "key": "file.txt"
            }
        }
    ]
}

first_event = sample_cloudtrail["Records"][0]
print(f"Here is fisrst strig: {first_event}\n")  # CreateBucket


first_user_name = first_event["userIdentity"]["userName"]
print(f"Here is first user name: {first_user_name}\n")  # alice

# find all envent by alice
alice_events = []
first_user_name = first_event["userIdentity"]["userName"]
for record in sample_cloudtrail["Records"]:
	if record["userIdentity"]["userName"] == "alice":
		alice_events.append(record["eventName"]) # CreateBucket

print(f"Here is all events by alice: {alice_events}\n")  # ['CreateBucket']

