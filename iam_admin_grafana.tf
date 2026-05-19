data "aws_iam_policy_document" "admin_grafana" {
  statement {
    sid    = "GrafanaWorkspaceAdmin"
    effect = "Allow"
    actions = [
      "grafana:CreateWorkspace",
      "grafana:DeleteWorkspace",
      "grafana:DescribeWorkspace",
      "grafana:DescribeWorkspaceAuthentication",
      "grafana:DescribeWorkspaceConfiguration",
      "grafana:ListWorkspaces",
      "grafana:ListPermissions",
      "grafana:UpdatePermissions",
      "grafana:UpdateWorkspace",
      "grafana:UpdateWorkspaceAuthentication",
      "grafana:UpdateWorkspaceConfiguration",
      "grafana:AssociateLicense",
      "grafana:DisassociateLicense",
      "grafana:CreateWorkspaceApiKey",
      "grafana:DeleteWorkspaceApiKey",
      "grafana:ListWorkspaceServiceAccounts",
      "grafana:CreateWorkspaceServiceAccount",
      "grafana:DeleteWorkspaceServiceAccount",
      "grafana:CreateWorkspaceServiceAccountToken",
      "grafana:DeleteWorkspaceServiceAccountToken",
    ]
    resources = [
      aws_grafana_workspace.monitoring.arn,
      "${aws_grafana_workspace.monitoring.arn}/*",
    ]
  }

  statement {
    sid    = "PassGrafanaWorkspaceRole"
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      aws_iam_role.grafana_workspace.arn,
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["grafana.amazonaws.com"]
    }
  }

  statement {
    sid    = "IamRoleRead"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:ListRoles",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
    ]
    resources = [
      aws_iam_role.grafana_workspace.arn,
    ]
  }

  statement {
    sid    = "CloudWatchDescribe"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user" "admin_grafana" {
  name = "Admin_grafana"
  tags = local.tags
}

resource "aws_iam_policy" "admin_grafana" {
  name        = "${var.workspace_name}-admin-grafana"
  description = "Administrative access to the Amazon Managed Grafana workspace for Admin_grafana."
  policy      = data.aws_iam_policy_document.admin_grafana.json
  tags        = local.tags
}

resource "aws_iam_user_policy_attachment" "admin_grafana" {
  user       = aws_iam_user.admin_grafana.name
  policy_arn = aws_iam_policy.admin_grafana.arn
}

resource "aws_iam_access_key" "admin_grafana" {
  count = var.create_admin_access_key ? 1 : 0
  user  = aws_iam_user.admin_grafana.name
}
