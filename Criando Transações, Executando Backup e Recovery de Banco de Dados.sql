## Criando Transações, Executando Backup e Recovery de Banco de Dados

### Transações

Transações são usadas para garantir que um conjunto de operações no banco de dados seja executado de maneira atômica, consistente, isolada e durável (propriedades ACID). A seguir, vamos ver como criar e gerenciar transações no MySQL.

#### Exemplo de Transação

Vamos criar uma transação para inserir um pedido e seus pagamentos associados. Se qualquer etapa falhar, a transação será revertida.

```sql
START TRANSACTION;

BEGIN;

-- Inserir um novo pedido
INSERT INTO Pedidos (id_cliente, data_pedido, total) VALUES (1, '2024-06-30', 150.00);

-- Obter o ID do pedido recém-inserido
SET @id_pedido = LAST_INSERT_ID();

-- Inserir formas de pagamento associadas ao pedido
INSERT INTO Pagamentos (id_pedido, forma_pagamento, valor) VALUES (@id_pedido, 'Cartão de Crédito', 100.00);
INSERT INTO Pagamentos (id_pedido, forma_pagamento, valor) VALUES (@id_pedido, 'Boleto', 50.00);

-- Se todas as operações forem bem-sucedidas, confirma a transação
COMMIT;

-- Se ocorrer um erro, reverte a transação
ROLLBACK;
```

### Backup de Banco de Dados

O backup é essencial para proteger os dados contra perdas. No MySQL, o utilitário `mysqldump` é amplamente utilizado para realizar backups.

#### Executando um Backup com `mysqldump`

```sh
mysqldump -u root -p database_name > backup_database_name.sql
```

- `-u root`: Especifica o usuário do MySQL.
- `-p`: Solicita a senha do usuário.
- `database_name`: Nome do banco de dados a ser backupado.
- `> backup_database_name.sql`: Nome do arquivo onde o backup será salvo.

### Recovery de Banco de Dados

Para restaurar um banco de dados a partir de um arquivo de backup, usamos o comando `mysql`.

#### Restaurando um Backup

```sh
mysql -u root -p database_name < backup_database_name.sql
```

- `-u root`: Especifica o usuário do MySQL.
- `-p`: Solicita a senha do usuário.
- `database_name`: Nome do banco de dados onde os dados serão restaurados.
- `< backup_database_name.sql`: Arquivo de backup a ser restaurado.

### Automação de Backup e Recovery com Scripts

Para automatizar o processo de backup e recovery, podemos criar scripts em bash.

#### Script de Backup Automático

Crie um arquivo chamado `backup.sh`:

```sh
#!/bin/bash

# Variáveis de configuração
USER="root"
PASSWORD="your_password"
DATABASE="database_name"
BACKUP_DIR="/path/to/backup"
DATE=$(date +%F)

# Comando de backup
mysqldump -u $USER -p$PASSWORD $DATABASE > $BACKUP_DIR/backup_$DATABASE_$DATE.sql

# Mensagem de sucesso
echo "Backup realizado com sucesso em $BACKUP_DIR/backup_$DATABASE_$DATE.sql"
```

Torne o script executável:

```sh
chmod +x backup.sh
```

Agende o script para ser executado diariamente usando o `cron`. Edite o crontab:

```sh
crontab -e
```

Adicione a linha abaixo para agendar a execução diária às 2:00 AM:

```sh
0 2 * * * /path/to/backup.sh
```

### Considerações Finais

Utilizando transações, backups e recovery, você pode garantir a integridade e a disponibilidade dos dados no seu banco de dados MySQL. As transações protegem suas operações de escrita contra falhas, enquanto os backups regulares garantem que você possa restaurar seus dados em caso de perda ou corrupção. Automatizar esses processos aumenta a confiabilidade e reduz o risco de erro humano.
