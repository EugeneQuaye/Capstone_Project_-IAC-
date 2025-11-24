resource "aws_lambda_function" "translate_function" {
  filename         = "lambda_function_payload.zip"
  function_name    = "translate-json-files"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  environment {
    variables = {
      RESPONSE_BUCKET = var.response_bucket
    }
  }
}