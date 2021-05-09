data "template_file" "greeting" {
  template = <<-EOT
  #/bin/bash

  echo "${var.greeting}"
  EOT
}

resource "local_file" "greeting" {
  content  = data.template_file.greeting.rendered
  filename = "${path.module}/greeting.sh"
}
