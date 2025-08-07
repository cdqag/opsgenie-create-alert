# Action OpsGenie Create Alert

This GitHub Action creates an alerts in [OpsGenie](https://www.atlassian.com/software/opsgenie).

## Pre-requisites

To use this GitHub Action, you need to have:

* an OpsGenie account and an API key
* have following tools installed on your runner: jq, curl (both are usually pre-installed on GitHub-hosted runners, but you might need to install them on self-hosted runners)

## Usage

```yaml
- uses: cdqag/action-opsgenie-create-alert@v1
  with:
    apiKey: secret
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

Please note that fields that are _arrays_ or _objects_ should be valid JSON arrays/objects. See examples below.

### Example

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
          message: "${{ github.workflow }} #${{ github.run_number }} failed"
          description: | # Description supports HTML (according to OpsGenie specs)
            Run number ${{ github.run_number }} of workflow <i>${{ github.workflow }}</i> has failed!<br>
            <a href="${{ env.RUN_URL }}" target="_blank">Open run in new window</a>  
          tags: '["tag1", "tag2"]'  # Note that this is an JSON array but between apostophes. You can use doublequotes, but you will need to do the escaping.
          
 
```

### Debugging

To see the debug logs (for _curl_ too), you can either click checkbox _Enable debug logging_ while re-running the failed job
or you can enable debugging for whole repo by adding the following secret to your repository: `ACTIONS_STEP_DEBUG` with value `true`.
You can read more about it [here](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/enabling-debug-logging#enabling-step-debug-logging).

## Resources

* Create OpsGenie API key with [an API integration](https://support.atlassian.com/opsgenie/docs/create-a-default-api-integration/)
* [OpsGenie AlertAPI](https://docs.opsgenie.com/docs/alert-api#create-alert)

## License

This project is licensed under the Apache-2.0 License. See the [LICENSE](LICENSE) file for details.
