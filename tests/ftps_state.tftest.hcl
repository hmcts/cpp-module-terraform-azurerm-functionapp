mock_provider "azurerm" {
  mock_data "azurerm_service_plan" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/ftp-test/providers/Microsoft.Web/serverFarms/ftp-test"
    }
  }
}

variables {
  resource_group_name        = "ftp-test"
  service_plan_name          = "ftp-test"
  function_app_name          = "ftp-test"
  storage_account_name       = "ftptest"
  storage_account_access_key = "bW9jay1zdG9yYWdlLWtleQ=="
  create_service_plan        = false
  asp_os_type                = "Linux"
}

run "consumer_provider_version" {
  command = plan

  module {
    source = "./tests/fixtures/providers"
  }
}

run "linux_omitted_disables_ftp" {
  command = plan

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Omitted site_config must disable FTP on Linux."
  }
}

run "windows_omitted_disables_ftp" {
  command = plan

  variables {
    asp_os_type = "Windows"
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Omitted site_config must disable FTP on Windows."
  }
}

run "linux_empty_disables_ftp" {
  command = plan

  variables {
    site_config = {}
  }

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Empty site_config must disable FTP on Linux."
  }
}

run "windows_empty_disables_ftp" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = {}
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Empty site_config must disable FTP on Windows."
  }
}

run "linux_null_config_disables_ftp" {
  command = plan

  variables {
    site_config = null
  }

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Null site_config must disable FTP on Linux."
  }
}

run "windows_null_config_disables_ftp" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = null
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Null site_config must disable FTP on Windows."
  }
}

run "linux_null_field_disables_ftp" {
  command = plan

  variables {
    site_config = { ftps_state = null }
  }

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "A null FTP field must disable FTP on Linux."
  }
}

run "windows_null_field_disables_ftp" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = { ftps_state = null }
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "A null FTP field must disable FTP on Windows."
  }
}

run "linux_explicit_disabled" {
  command = plan

  variables {
    site_config = { ftps_state = "Disabled" }
  }

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Explicit Disabled must reach the Linux resource."
  }
}

run "windows_explicit_disabled" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = { ftps_state = "Disabled" }
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "Disabled"
    error_message = "Explicit Disabled must reach the Windows resource."
  }
}

run "linux_ftps_only" {
  command = plan

  variables {
    site_config = { ftps_state = "FtpsOnly" }
  }

  assert {
    condition     = azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "FtpsOnly"
    error_message = "FtpsOnly must reach the Linux resource."
  }
}

run "windows_ftps_only" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = { ftps_state = "FtpsOnly" }
  }

  assert {
    condition     = azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "FtpsOnly"
    error_message = "FtpsOnly must reach the Windows resource."
  }
}

run "linux_caller_merge_preserves_options" {
  command = plan

  variables {
    site_config = merge({
      ftps_state   = "FtpsOnly"
      always_on    = true
      worker_count = 2
      cors = {
        allowed_origins     = ["https://example.invalid"]
        support_credentials = true
      }
      application_stack = { python_version = "3.11" }
      }, {
      application_insights_connection_string = "InstrumentationKey=00000000-0000-0000-0000-000000000000"
    })
  }

  assert {
    condition = (
      azurerm_linux_function_app.linux_function[0].site_config[0].ftps_state == "FtpsOnly" &&
      azurerm_linux_function_app.linux_function[0].site_config[0].always_on &&
      azurerm_linux_function_app.linux_function[0].site_config[0].worker_count == 2 &&
      azurerm_linux_function_app.linux_function[0].site_config[0].cors[0].support_credentials &&
      contains(azurerm_linux_function_app.linux_function[0].site_config[0].cors[0].allowed_origins, "https://example.invalid") &&
      azurerm_linux_function_app.linux_function[0].site_config[0].application_stack[0].python_version == "3.11" &&
      azurerm_linux_function_app.linux_function[0].site_config[0].application_insights_connection_string == "InstrumentationKey=00000000-0000-0000-0000-000000000000"
    )
    error_message = "Caller-style merging must preserve FTP, numeric, boolean and nested Linux options."
  }
}

run "windows_caller_merge_preserves_options" {
  command = plan

  variables {
    asp_os_type = "Windows"
    site_config = merge({
      ftps_state   = "FtpsOnly"
      always_on    = true
      worker_count = 2
      cors = {
        allowed_origins     = ["https://example.invalid"]
        support_credentials = true
      }
      application_stack = { dotnet_version = "v8.0" }
      }, {
      application_insights_connection_string = "InstrumentationKey=00000000-0000-0000-0000-000000000000"
    })
  }

  assert {
    condition = (
      azurerm_windows_function_app.windows_function[0].site_config[0].ftps_state == "FtpsOnly" &&
      azurerm_windows_function_app.windows_function[0].site_config[0].always_on &&
      azurerm_windows_function_app.windows_function[0].site_config[0].worker_count == 2 &&
      azurerm_windows_function_app.windows_function[0].site_config[0].cors[0].support_credentials &&
      contains(azurerm_windows_function_app.windows_function[0].site_config[0].cors[0].allowed_origins, "https://example.invalid") &&
      azurerm_windows_function_app.windows_function[0].site_config[0].application_stack[0].dotnet_version == "v8.0" &&
      azurerm_windows_function_app.windows_function[0].site_config[0].application_insights_connection_string == "InstrumentationKey=00000000-0000-0000-0000-000000000000"
    )
    error_message = "Caller-style merging must preserve FTP, numeric, boolean and nested Windows options."
  }
}

run "linux_no_function_app" {
  command = plan

  variables {
    create_function_app = false
    create_service_plan = true
    site_config         = null
  }

  assert {
    condition = (
      length(azurerm_linux_function_app.linux_function) == 0 &&
      length(azurerm_windows_function_app.windows_function) == 0 &&
      length(azurerm_service_plan.main) == 1
    )
    error_message = "Disabling Function creation must retain service-plan-only behavior on Linux."
  }
}

run "windows_no_function_app" {
  command = plan

  variables {
    asp_os_type         = "Windows"
    create_function_app = false
    create_service_plan = true
    site_config         = null
  }

  assert {
    condition = (
      length(azurerm_linux_function_app.linux_function) == 0 &&
      length(azurerm_windows_function_app.windows_function) == 0 &&
      length(azurerm_service_plan.main) == 1
    )
    error_message = "Disabling Function creation must retain service-plan-only behavior on Windows."
  }
}

run "reject_all_allowed" {
  command = plan
  variables {
    site_config = { ftps_state = "AllAllowed" }
  }
  expect_failures = [var.site_config]
}

run "reject_empty_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = "" }
  }
  expect_failures = [var.site_config]
}

run "reject_whitespace_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = " " }
  }
  expect_failures = [var.site_config]
}

run "reject_lowercase_disabled" {
  command = plan
  variables {
    site_config = { ftps_state = "disabled" }
  }
  expect_failures = [var.site_config]
}

run "reject_lowercase_ftps_only" {
  command = plan
  variables {
    site_config = { ftps_state = "ftpsonly" }
  }
  expect_failures = [var.site_config]
}

run "reject_padded_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = " FtpsOnly " }
  }
  expect_failures = [var.site_config]
}

run "reject_unsupported_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = "Enabled" }
  }
  expect_failures = [var.site_config]
}

run "reject_numeric_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = 1 }
  }
  expect_failures = [var.site_config]
}

run "reject_boolean_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = true }
  }
  expect_failures = [var.site_config]
}

run "reject_list_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = ["FtpsOnly"] }
  }
  expect_failures = [var.site_config]
}

run "reject_object_ftp" {
  command = plan
  variables {
    site_config = { ftps_state = { mode = "FtpsOnly" } }
  }
  expect_failures = [var.site_config]
}

run "reject_string_config" {
  command = plan
  variables {
    site_config = "FtpsOnly"
  }
  expect_failures = [var.site_config]
}

run "reject_numeric_config" {
  command = plan
  variables {
    site_config = 1
  }
  expect_failures = [var.site_config]
}

run "reject_boolean_config" {
  command = plan
  variables {
    site_config = true
  }
  expect_failures = [var.site_config]
}

run "reject_list_config" {
  command = plan
  variables {
    site_config = ["FtpsOnly"]
  }
  expect_failures = [var.site_config]
}

run "reject_set_config" {
  command = plan
  variables {
    site_config = toset(["FtpsOnly"])
  }
  expect_failures = [var.site_config]
}