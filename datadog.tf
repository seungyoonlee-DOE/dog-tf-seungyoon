terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
}

resource "datadog_monitor" "test_cpuutilization" {
  name              = "[Terraform-Test] {{service.name}} 서비스 {{host.name}} CPU 사용률이 {{value}} 입니다."
  type              = "query alert"
  query             = "avg(last_5m):100 - avg:system.cpu.idle{env:production} by {service,host} > 90"
  message           = <<EOF
{{#is_alert}}
{{service.name}} 서비스 {{host.name}} 인스턴스의 CPU 사용률이 {{value}} 입니다.
@slack-SEO-datadog_test
{{/is_alert}} 

{{#is_warning}}
{{service.name}} 서비스 {{host.name}} 인스턴스의 CPU 사용률이 {{value}} 입니다.
@slack-SEO-datadog_test
{{/is_warning}} 

{{#is_recovery}}
알람이 해제되었습니다.
{{service.name}} 서비스 {{host.name}} 인스턴스의 CPU 사용률이 {{value}} 입니다.
@slack-SEO-datadog_test
{{/is_recovery}}
  EOF
  tags              = ["EC2", "env:production"]
  monitor_thresholds {
    critical = 90
    warning = 80
  }
  priority          = 3

}