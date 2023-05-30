terraform {

}

provider "oci" {

}

resource "oci_core_vcn" "example_vcn" {
  dns_label = "exampleVcn"
  cidr_block = "172.16.0.0/20"
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaxqtkjrprsuprfjn4jovmifo56yksxlrs7b3lhmquqec2wpjufxza"
  display_name = "Terraform VCN"
}

resource "oci_core_subnet" "example_subnet" {
  vcn_id                     = oci_core_vcn.example_vcn.id
  cidr_block                 = "172.16.0.0/24"
  compartment_id             = "ocid1.tenancy.oc1..aaaaaaaaxqtkjrprsuprfjn4jovmifo56yksxlrs7b3lhmquqec2wpjufxza"
  display_name               = "Terraform VCN subnet"
  dns_label                  = "exampleSubnet"
  prohibit_public_ip_on_vnic = true
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaxqtkjrprsuprfjn4jovmifo56yksxlrs7b3lhmquqec2wpjufxza"
  ad_number = 1
}

resource "oci_core_instance" "example_instance" {
  display_name = "Example Instance"
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = "ocid1.tenancy.oc1..aaaaaaaaxqtkjrprsuprfjn4jovmifo56yksxlrs7b3lhmquqec2wpjufxza"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id = oci_core_subnet.example_subnet.id
    assign_public_ip = "False"
  }

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaapwotlpqctjugilokte7y7dk5iimnusvygtlsxdfcaif26lzvek7a"
    source_type = "image"
  }
}