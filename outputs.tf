output "appautoscaling_read_policy_arn" {
  value       = aws_appautoscaling_policy.read_policy[0].arn
  description = "Appautoscaling read policy ARN"
}

output "appautoscaling_write_policy_arn" {
  value       = aws_appautoscaling_policy.write_policy[0].arn
  description = "Appautoscaling write policy ARN"
}
