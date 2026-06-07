var database = require("../database/config");


function buscarUltimasLeituras(idCanavial, limite_linhas) {

    var instrucaoSql = `
        SELECT 
            l.valor_gas,
            l.data_hora,
            DATE_FORMAT(l.data_hora, '%H:%i:%s') AS momento_grafico,
            s.id AS id_sensor,
            s.unidade_medida
        FROM leitura l
        INNER JOIN sensor s ON l.fk_sensor = s.id
        WHERE s.fk_canavial = ${idCanavial}
        ORDER BY l.id DESC
        LIMIT ${limite_linhas}
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


function buscarLeituraEmTempoReal(idCanavial) {

    var instrucaoSql = `
        SELECT 
            l.valor_gas,
            l.data_hora,
            DATE_FORMAT(l.data_hora, '%H:%i:%s') AS momento_grafico,
            s.id AS id_sensor,
            s.fk_canavial
        FROM leitura l
        INNER JOIN sensor s ON l.fk_sensor = s.id
        WHERE s.fk_canavial = ${idCanavial}
        ORDER BY l.id DESC
        LIMIT 1
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarUltimasLeituras,
    buscarLeituraEmTempoReal
};
