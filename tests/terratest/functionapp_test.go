package test

import (
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"path/filepath"
	"strconv"
	"testing"
)

//Testing the secure-file-transfer Module
func TestTerraformAzureFunctionApp(t *testing.T) {
	t.Parallel()

	//subscriptionID := "e6b5053b-4c38-4475-a835-a025aeb3d8c7"
	// Terraform plan.out File Path
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../..", "examples/complete")
	planFilePath := filepath.Join(exampleFolder, "plan.out")

	terraformPlanOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,

		// Variables to pass to our Terraform code using -var options
		VarFiles: []string{"for_terratest.tfvars"},

		//Environment variables to set when running Terraform

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: planFilePath,
	})

	// Run terraform init plan and show and fail the test if there are any errors
	terraform.InitAndPlanAndShowWithStruct(t, terraformPlanOptions)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformPlanOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformPlanOptions)

	// Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformPlanOptions, "resource_group_name")
	functionAppName := terraform.Output(t, terraformPlanOptions, "function_app_name")
	functionAppId := terraform.Output(t, terraformPlanOptions, "function_app_id")
	functionAppWorkerCount, _ := strconv.ParseInt(terraform.Output(t, terraformPlanOptions, "function_app_worker_count"), 10, 32)

	// Assert statements
	assert.True(t, azure.AppExists(t, functionAppName, resourceGroupName, ""))
	site := azure.GetAppService(t, functionAppName, resourceGroupName, "")

	assert.Equal(t, functionAppId, *site.ID)
	assert.Equal(t, functionAppName+".azurewebsites.net", *site.DefaultHostName)
	assert.Equal(t, int32(functionAppWorkerCount), *site.SiteConfig.NumberOfWorkers)
	assert.NotEmpty(t, *site.OutboundIPAddresses)
	assert.Equal(t, "Running", *site.State)
}
