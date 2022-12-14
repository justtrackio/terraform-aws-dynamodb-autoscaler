resource "aws_appautoscaling_target" "read_target" {
  count              = module.this.enabled ? 1 : 0
  max_capacity       = var.autoscale_max_read_capacity
  min_capacity       = var.autoscale_min_read_capacity
  resource_id        = "table/${var.dynamodb_table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "read_target_index" {
  for_each           = module.this.enabled ? toset(var.dynamodb_indexes) : toset([])
  max_capacity       = coalesce(var.autoscale_max_read_capacity_index, var.autoscale_max_read_capacity)
  min_capacity       = coalesce(var.autoscale_min_read_capacity_index, var.autoscale_min_read_capacity)
  resource_id        = "table/${var.dynamodb_table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  count       = module.this.enabled ? 1 : 0
  name        = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target[0].id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.read_target[0].resource_id

  scalable_dimension = aws_appautoscaling_target.read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.autoscale_read_target
  }
}

resource "aws_appautoscaling_policy" "read_policy_index" {
  for_each = module.this.enabled ? toset(var.dynamodb_indexes) : toset([])

  name = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target_index[each.key].id}"

  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target_index[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target_index[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target_index[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = coalesce(var.autoscale_read_target_index, var.autoscale_read_target)
  }
}

resource "aws_appautoscaling_target" "write_target" {
  count              = module.this.enabled ? 1 : 0
  max_capacity       = var.autoscale_max_write_capacity
  min_capacity       = var.autoscale_min_write_capacity
  resource_id        = "table/${var.dynamodb_table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write_target_index" {
  for_each           = module.this.enabled ? toset(var.dynamodb_indexes) : toset([])
  max_capacity       = coalesce(var.autoscale_max_write_capacity_index, var.autoscale_max_write_capacity)
  min_capacity       = coalesce(var.autoscale_min_write_capacity_index, var.autoscale_min_write_capacity)
  resource_id        = "table/${var.dynamodb_table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  count       = module.this.enabled ? 1 : 0
  name        = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target[0].id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.write_target[0].resource_id

  scalable_dimension = aws_appautoscaling_target.write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.autoscale_write_target
  }
}

resource "aws_appautoscaling_policy" "write_policy_index" {
  for_each = module.this.enabled ? toset(var.dynamodb_indexes) : toset([])

  name = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target_index[each.key].id}"

  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target_index[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target_index[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target_index[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = coalesce(var.autoscale_write_target_index, var.autoscale_write_target)
  }
}
