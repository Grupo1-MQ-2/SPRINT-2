var database = require("../database/config");


function buscarPorId(id) {
  var instrucaoSql = `SELECT * FROM empresa WHERE id = '${id}'`;

  return database.executar(instrucaoSql);
}

function listar() {
  var instrucaoSql = `SELECT id, razao_social, cnpj, codigo_ativacao FROM empresa`;

  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `SELECT * FROM empresa WHERE cnpj = '${cnpj}'`;

  return database.executar(instrucaoSql);
}

function autenticar(cnpj, codigo, senha) {
  console.log("ACESSEI O EMPRESA MODEL para autenticar:", cnpj, codigo);

  var instrucaoSql = `
        SELECT id, cnpj, nome_fantasia FROM empresa WHERE cnpj = '${cnpj}' AND codigo_ativacao = '${codigo}' AND senha = '${senha}';
    `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function autenticarRepresentante(email, codigo, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ", email, codigo, senha)
    var instrucaoSql = `
        SELECT id, nome, email, fk_empresa as empresaId FROM representante WHERE email = '${email}' AND codigo_ativacao = '${codigo}' AND senha = '${senha}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrar(razaoSocial, nomeFantasia, cnpj, senha, logradouro, numero, complemento, cep, estado, cidade, fkAssinatura, nomeCanavial, coordenadasCanavial, nome, email, dataNascimento, senhaRepresentante, codigoAtivacao) {
  var instrucaoSqlEmpresa = `INSERT INTO empresa (fk_assinatura, razao_social, nome_fantasia, cnpj, senha, codigo_ativacao)
  VALUES (${fkAssinatura}, '${razaoSocial}', '${nomeFantasia}', '${cnpj}', '${senha}', '${codigoAtivacao}')`;

  console.log("Executando a instrução SQL Empresa: \n" + instrucaoSqlEmpresa);
  
  return database.executar(instrucaoSqlEmpresa).then((resultado) => {
    var fkEmpresa = resultado.insertId;

    var instrucaoSqlLocalizacao = `INSERT INTO localizacaoEmpresa (fk_empresa, logradouro, numero, complemento, CEP, cidade, estado)
    VALUES (${fkEmpresa}, '${logradouro}', ${numero}, '${complemento}', '${cep}', '${cidade}', '${estado}')`;

    var instrucaoSqlCanavial = `INSERT INTO canavial (fk_empresa, nome, coordenada)
    VALUES (${fkEmpresa}, '${nomeCanavial}', '${coordenadasCanavial}')`;

    var instrucaoSqlRepresentante = `INSERT INTO representante (fk_empresa, nome, email, dt_nascimento, senha, codigo_ativacao)
    VALUES (${fkEmpresa}, '${nome}', '${email}', '${dataNascimento}', '${senhaRepresentante}', '${codigoAtivacao}')`;

    console.log("Executando relacionamentos para fk_empresa: " + fkEmpresa);
    return Promise.all([
      database.executar(instrucaoSqlLocalizacao),
      database.executar(instrucaoSqlCanavial),
      database.executar(instrucaoSqlRepresentante)
    ]).then(() => resultado);
  });
}

module.exports = { buscarPorCnpj, buscarPorId, autenticar, autenticarRepresentante, cadastrar, listar };
