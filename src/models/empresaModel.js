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

function cadastrar(razaoSocial, nomeFantasia, cnpj, senha, codigoAtivacao) {
  var instrucaoSql = `INSERT INTO empresa (razao_social, nome_fantasia, cnpj, senha, codigo_ativacao)
  VALUES ('${razaoSocial}', '${nomeFantasia}', '${cnpj}', '${senha}', '${codigoAtivacao}')`;

  console.log("Executando a instrução SQL: \n + instrucaoSql");
  return database.executar(instrucaoSql);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar };
