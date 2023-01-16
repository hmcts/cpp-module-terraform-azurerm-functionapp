## About
This directory contains unit tests and integration tests.
The integration tests use the [examples-complete](../../examples/complete). This will create a
function app and related resources which will be tested to ensure they are built correctly.


## Usage

From the root of the repo run
go mod init github.com/hmcts/cpp-module-terraform-azurerm-functionapp

To execute the tests execute the following from within the test file's folder:

Ensure your go environment is setup with the required go version running on pipeline. You can check [cpp-azure-devops-templates](https://github.com/hmcts/cpp-azure-devops-templates/blob/main/pipelines/terratest.yaml#L13) repo

```bash
 brew unlink go
 brew link go@1.18 --overwrite
 ```

```bash
go test -v pre_test.go
```

Run the terratest which will validate the module.
```bash
az login (non-live)
az account set --subscription 8cdb5405-7535-4349-92e9-f52bddc7833a
go test -v -timeout 30m functionapp_test.go
```
