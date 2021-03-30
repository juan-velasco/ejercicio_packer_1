source "azure-arm" "my-site" {
 
  # datos de la imagen raíz
  os_type = "Linux"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-focal"
  image_sku = "20_04-lts"
  image_version = "latest" #de esta forma siempre tendremos el SO actualizado
  
  azure_tags = {
    environment = "curso"
  }

  location = "West Europe"
  vm_size = "Standard_A2" #tamaño de máquina que se usará para generar la imagen

  # resultado, imagen destino
  subscription_id = "7c695ada-05eb-4f32-bbdf-4875a45e4061" # Obtener con "az account list"
  managed_image_name = "my_site_{{ uuid }}"
  managed_image_resource_group_name = "ejercicio_packer" # el grupo de recursos debe estar previamente creado
}

build {
  sources = ["sources.azure-arm.my-site"]

    provisioner "shell" {
      inline = [
        "set -e #aborta el comando en caso de error",
        "sudo timedatectl set-timezone Europe/Madrid"
      ]
    }

    provisioner "ansible" {    
      playbook_file = "provisioners/ansible/instalar_aplicacion.yml"
      groups = ["curso"]
      extra_arguments = [
          "--extra-vars",
          "mysql_root_password=1q2w3e4r5t6y admin_user=www-data"
      ]
    }
}
