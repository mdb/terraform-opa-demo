resource "local_file" "greeting" {
  content  = templatefile("${path.module}/greeting.tftpl", {greeting = var.greeting})
  filename = "${path.module}/greeting.sh"
}
