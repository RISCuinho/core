YOSYS
=====

Este projeto usa o YOSYS para gerar o RTLView do projeto, criando um diagrama dos módulos e sua composição. 

Deve ser usado a versão mais atual disponível no repositório: https://github.com/RISCuinho/yosys


## Build YOSYS

O YOSYS deve ser compilado da seguinte forma:

* Certifique-se que todas as dependẽncias estejam instaladas
* Use a versão 0.9, para isso mude para a tag `git checkout yosys-0.9`
* Crie a pasta "build" e entre nela para construir o projeto
* Configure o GCC com o comando `make -f ..\Makefile config-gcc`
* Configure o SUDO `make -f ..\Makefile config-sudo`
* Compile usando o comando `make -f ..\Makefile`
* Instale o novo YOSYS `make -f ..\Makefile PREFIX=/opt/yosys install`
* Autalize seu path com o diretório usado em `PREFIX` adicionando `/bin` no caso `/opt/yosys/bin`

