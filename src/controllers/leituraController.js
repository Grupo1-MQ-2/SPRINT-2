var leituraModel = require("../models/leituraModel");

function buscarUltimasLeituras(req, res) {

    const limite_linhas = 7;

    var idCanavial = req.params.idCanavial;

    console.log(`Recuperando as últimas ${limite_linhas} leituras do canavial ${idCanavial}`);

    leituraModel.buscarUltimasLeituras(idCanavial, limite_linhas).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!");
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as últimas leituras.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function buscarLeituraEmTempoReal(req, res) {

    var idCanavial = req.params.idCanavial;

    console.log(`Recuperando leitura em tempo real do canavial ${idCanavial}`);

    leituraModel.buscarLeituraEmTempoReal(idCanavial).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!");
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar a leitura em tempo real.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

module.exports = {
    buscarUltimasLeituras,
    buscarLeituraEmTempoReal
};
