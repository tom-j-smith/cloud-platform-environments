resource "aws_apigatewayv2_api" "gateway" {
  name = var.api_gateway_name
  protocol_type = "HTTP"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_apigatewayv2_authorizer" "auth" {
  api_id           = aws_apigatewayv2_api.gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.pool.endpoint}"
  }
}

resource "aws_apigatewayv2_integration" "test_api" {
  api_id                          = aws_apigatewayv2_api.gateway.id
  integration_method              = "ANY"
  connection_type                 = "INTERNET"
  integration_type                = "HTTP_PROXY"
  integration_uri                 = "https://${aws_apigatewayv2_api.gateway.id}.execute-api.${var.apigw_region}.amazonaws.com/${var.apigw_stage_name}/test"        
  passthrough_behavior            = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "ANY /test"
  target = "integrations/${aws_apigatewayv2_integration.test_api.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
  authorization_scopes = aws_cognito_resource_server.resource.scope_identifiers
}

resource "aws_apigatewayv2_deployment" "deployment" {
  api_id      = aws_apigatewayv2_api.gateway.id
  description = "API Gateway deployment"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_apigatewayv2_integration.test_api),
      jsonencode(aws_apigatewayv2_route.route),
    )))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_apigatewayv2_api.gateway,
    aws_apigatewayv2_integration.test_api,
    aws_apigatewayv2_route.route
  ]
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.gateway.id
  name   = var.apigw_stage_name
  deployment_id = aws_apigatewayv2_deployment.deployment.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_apigatewayv2_api.gateway,
    aws_apigatewayv2_deployment.deployment
  ]

  default_route_settings {
    logging_level = "INFO"
    detailed_metrics_enabled = true
  }

}
