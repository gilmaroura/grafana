data "aws_iam_policy_document" "grafana_workspace_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "grafana_workspace_monitoring" {
  # CloudWatch metrics and alarms
  statement {
    sid    = "CloudWatchRead"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:GetInsightRuleReport",
    ]
    resources = ["*"]
  }

  # CloudWatch Logs
  statement {
    sid    = "CloudWatchLogsRead"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:GetLogGroupFields",
      "logs:GetLogRecord",
      "logs:GetQueryResults",
      "logs:FilterLogEvents",
      "logs:StartQuery",
      "logs:StopQuery",
    ]
    resources = ["*"]
  }

  # Resource discovery for dashboards (Permissões de leitura para descobrir recursos e montar filtros)
  statement {
    sid    = "ResourceDiscovery"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "lambda:ListFunctions",
      "lambda:GetFunction",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "autoscaling:DescribeAutoScalingGroups",
      "sns:ListTopics",
      "sns:ListSubscriptions",
      "sqs:ListQueues",
      "s3:ListAllMyBuckets",
      "aps:ListWorkspaces",
      "aps:DescribeWorkspace",
    ]
    resources = ["*"] # AMG precisa de "*" para listar recursos entre a conta
  }

  statement {
    sid    = "TaggingRead"
    effect = "Allow"
    actions = [
      "tag:GetResources",
    ]
    resources = ["*"]
  }

  # X-Ray traces
  statement {
    sid    = "XRayRead"
    effect = "Allow"
    actions = [
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries",
      "xray:GetTraceGraph",
      "xray:GetServiceGraph",
      "xray:GetTimeSeriesServiceStatistics",
      "xray:GetInsightSummaries",
      "xray:GetInsight",
      "xray:GetGroups",
      "xray:GetGroup",
      "xray:ListTagsForResource",
    ]
    resources = ["*"]
  }

  # SNS for Grafana notification destinations
  statement {
    sid    = "SNSRead"
    effect = "Allow"
    actions = [
      "sns:ListTopics",
      "sns:GetTopicAttributes",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "grafana_workspace" {
  name               = "${var.workspace_name}-workspace-role"
  assume_role_policy = data.aws_iam_policy_document.grafana_workspace_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "grafana_workspace_monitoring" {
  name   = "${var.workspace_name}-monitoring"
  role   = aws_iam_role.grafana_workspace.id
  policy = data.aws_iam_policy_document.grafana_workspace_monitoring.json
}
