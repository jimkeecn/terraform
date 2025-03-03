resource "aws_dynamodb_table" "admin_portal_crs" {
  name         = "${var.client_name}.${var.environment}.AdminPortal.CRS"
  billing_mode = "PAY_PER_REQUEST"  # No need to define read/write capacity

  # Partition Key
  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  # Table class
  table_class = "STANDARD"  # DynamoDB Standard class

  # Stream disabled
  stream_enabled = false

  # Time-To-Live (TTL) disabled
  ttl {
    enabled = false
  }

  # Point-in-time recovery (PITR) disabled
  point_in_time_recovery {
    enabled = false
  }

  # Deletion protection disabled
  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.AdminPortal.CRS"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "admin_portal_mgmt_reports" {
  name         = "${var.client_name}.${var.environment}.AdminPortal.ManagementReports"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  
  }
  hash_key = "ID"

  table_class = "STANDARD" 

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.AdminPortal.ManagementReports"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "investor_portal_account_third_party_information" {
  name         = "${var.client_name}.${var.environment}.InvestorPortal.AccountThirdPartyInformation"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  
  }
  hash_key = "ID"

  table_class = "STANDARD"  

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.InvestorPortal.AccountThirdPartyInformation"
    Environment = "${var.environment}"
  }
}


resource "aws_dynamodb_table" "investor_portal_application_payment_information" {
  name         = "${var.client_name}.${var.environment}.InvestorPortal.ApplicationAndPaymentInformation"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.InvestorPortal.ApplicationAndPaymentInformation"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "investor_portal_application_receipt" {
  name         = "${var.client_name}.${var.environment}.InvestorPortal.ApplicationReceipt"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.InvestorPortal.ApplicationReceipt"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "investor_portal_investor_information" {
  name         = "${var.client_name}.${var.environment}.InvestorPortal.InvestorInformation"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.InvestorPortal.InvestorInformation"
    Environment = "${var.environment}"
  }
}


resource "aws_dynamodb_table" "investor_portal_page_state" {
  name         = "${var.client_name}.${var.environment}.InvestorPortal.PageState"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.InvestorPortal.PageState"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "admin_portal_user_batch" {
  name         = "${var.client_name}.${var.environment}.AdminPortal.UserBatch"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.AdminPortal.UserBatch"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "calastone_history_task" {
  name         = "${var.client_name}.${var.environment}.Calastone.History.Task"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.Calastone.History.Task"
    Environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "calastone_report" {
  name         = "${var.client_name}.${var.environment}.Calastone.Report"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.Calastone.Report"
    Environment = "${var.environment}"
  }
}


resource "aws_dynamodb_table" "calastone_task" {
  name         = "${var.client_name}.${var.environment}.Calastone.Task"
  billing_mode = "PAY_PER_REQUEST"  

  attribute {
    name = "ID"
    type = "S"  # String type
  }
  hash_key = "ID"

  table_class = "STANDARD"  # DynamoDB Standard class

  stream_enabled = false

  ttl {
    enabled = false
  }

  point_in_time_recovery {
    enabled = false
  }

  deletion_protection_enabled = false

  tags = {
    Name        = "${var.client_name}.${var.environment}.Calastone.Task"
    Environment = "${var.environment}"
  }
}