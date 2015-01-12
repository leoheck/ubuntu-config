
# Configuração das máquinas do GAPH

> Estes scripts estão atualmente otimizados para o Ubuntu 14.04. Contudo, é bem provavel que ele funcione para as próximas versões do sistema operacional.

Instale o Ubuntu seguindo a instalação padrão.

Configure o sistema em _Inglês_ para não ter problema com nome de diretórios.

Particione o primeiro disco conforme o esquema:
![Partition scheme](https://rawgit.com/leoheck/gaph-os-scripts/master/doc/figs/partitions.svg)

*Obs.: Se tiverem mais discos, crie um ponto de montagem de 1TB para o /sim*

Por fim, coloque suas credenciais de usuário.

Pergunte o _hostname_ para algum dos administradores

Não criptografe o disco!

## Para configurar o host:

```bash
wget https://github.com/leoheck/gaph-os-scripts/archive/master.zip
unzip master.zip
cd gaph-os-scripts-master
sudo ./config-gaph-host.sh
```



## Para instalar o grid: (todo)


