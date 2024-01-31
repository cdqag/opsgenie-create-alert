# OpsGenie Create Alert

This GitHub Action creates an alerts in [OpsGenie](https://www.atlassian.com/software/opsgenie).

## Usage

```yaml
- uses: cdqag/opsgenie-create-alert@v1
  with:
    api_key: secret
    message: your message
```

### Inputs

| Name          | Required | Description                                                                                                            | Limitations                               |
|---------------|----------|------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `apiUrl`      | **Yes**  | OpsGenie API URL (without `/alert` path). **Default**: https://api.opsgenie.com/v2                                     |                                           |
| `apiKey`      | **Yes**  | OpsGenie API Key                                                                                                       |                                           |
| `message`     | **Yes**  | Message of the alert                                                                                                   |                                           |
| `alias`       | No       | Client-defined identifier of the alert, that is also the key element of Alert De-Duplication                           | 512 characters                            |
| `description` | No       | Description field of the alert that is generally used to provide a detailed information about the alert                | 15000 characters                          |
| `responders`  | No       | An array of teams, users, escalations and schedules that the alert will be routed to                                   | 50 teams, users, escalations or schedules |
| `visibleTo`   | No       | An array of teams, users, escalations and schedules that the alert will be visible to without sending any notification | 50 teams or users in total                |
| `actions`     | No       | An array of custom actions that will be available for the alert                                                        | 10 x 50 characters                        |
| `tags`        | No       | An array of tags of the alert                                                                                          | 20 x 50 characters                        |
| `details`     | No       | Map of key-value pairs to use as custom properties of the alert                                                        | 8000 characters in total                  |
| `entity`      | No       | Entity field of the alert, that is generally used to specify which domain the alert is related to                      | 512 characters                            |
| `source`      | No       | Source field of the alert, that is used to carry where the alert is created                                            | 100 characters                            |
| `priority`    | No       | Priority level of the alert. Default value is P3.                                                                      | Possible values: P1, P2, P3, P4, P5       |
| `user`        | No       | Display name of the request owner                                                                                      | 100 characters                            |
| `note`        | No       | Additional note that will be added while creating the alert                                                            | 25000 characters                          |
| `verbose`     | No       | Enable verbose mode for _curl_                                                                                         |                                           |

Please note that fields that are _arrays_ or _objects_ should be valid JSON arrays/objects. See examples below.

### Examples

#### Send a message with tags, on job failure, using secret

```yaml
name: Example

on:
  workflow_dispatch:

env:
  RUN_URL: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}

jobs:
  example_job:
    runs-on: ubuntu-latest

    steps:
      - run: |
          echo "Oh no!"
          exit 1

      - if: failure()
        uses: cdqag/opsgenie-create-alert@v1
        with:
          apiKey: ${{ secrets.OPSGENIE_API_KEY }}
          message: "Run has failed: ${RUN_URL}"
          tags: '["tag1", "tag2"]'  # Note that this is an JSON array but between apostophes. You can use doublequotes, but you will need to do the escaping.
 
```

## Resources

* Create OpsGenie API key with [an API integration](https://support.atlassian.com/opsgenie/docs/create-a-default-api-integration/)
* [OpsGenie AlertAPI](https://docs.opsgenie.com/docs/alert-api#create-alert)

## License

This project is licensed under the MIT License. See the LICENSE file for details.
