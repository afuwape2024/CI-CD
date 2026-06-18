output "tier2_public_sg" {
  value = aws_security_group.tier2_public_sg.id
}
output "tier2_private_sg" {
  value = aws_security_group.tier2_private_sg.id
}
output "prometheus_sg" {
  value = aws_security_group.prometheus_sg.id
}
output "grafana_sg" {
  value =aws_security_group.grafana_sg.id
}
output "sonaque_sg" {
  value = aws_security_group.sonaque_sg.id
}
output "nexus_sg" {
  value =aws_security_group.nexus_sg.id
}