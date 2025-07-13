output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnets" {
    value  = aws_subnet.public[*].id
}

output "private_subnets" {
    value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
   value = aws_nat_gateway.natgw.id
}

output "public_instance_ip" {
    value  = aws_instance.public_ec2.public_ip
}

output "private_instance_id" {
    value = aws_instance.private_ec2.id
}
