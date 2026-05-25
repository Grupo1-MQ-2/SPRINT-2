// importando os bibliotecas necessárias
const { GoogleGenAI } = require("@google/genai");
const express = require("express");
const path = require("path");

// carregando as variáveis de ambiente do projeto do arquivo .env
require("dotenv").config();

// configurando o servidor express
const app = express();
const PORTA_SERVIDOR = process.env.PORTA;

// configurando o gemini (IA)
const chatIA = new GoogleGenAI({ apiKey: process.env.MINHA_CHAVE });

// configurando o servidor para receber requisições JSON
app.use(express.json());

// configurando o servidor para servir arquivos estáticos
app.use(express.static(path.join(__dirname, "public")));

// configurando CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
    next();
});

// inicializando o servidor
app.listen(PORTA_SERVIDOR, () => {
    console.info(
        `
        ######                ###    #    
        #     #  ####  #####   #    # #   
        #     # #    # #    #  #   #   #  
        ######  #    # #####   #  #     # 
        #     # #    # #    #  #  ####### 
        #     # #    # #    #  #  #     # 
        ######   ####  #####  ### #     # 
        `
    );
    console.info(`A API BobIA iniciada, acesse http://localhost:${PORTA_SERVIDOR}`);
});

// rota para receber perguntas e gerar respostas
app.post("/perguntar", async (req, res) => {
    const pergunta = req.body.pergunta;

    try {
        const resultado = await gerarResposta(pergunta);
        res.json({ resultado });
    } catch (error) {
        res.status(500).json({ error: 'Erro interno do servidor' });
    }

});

// função para gerar respostas usando o gemini
async function gerarResposta(mensagem) {

    try {
        // gerando conteúdo com base na pergunta
        const modeloIA = chatIA.models.generateContent({
            model: "gemini-2.5-flash",
            contents: 
            ` sabendo que 
    * **RF01:** O sistema deve capturar os dados de detecção de fumaça e gases de combustão em tempo real através do sensor MQ-2 conectado ao Arduino. 
    * **RF02:** O sistema deve transmitir os dados coletados pelo hardware para a aplicação utilizando a API Acqu-ino da SPTech. * 
    **RF03:** O sistema deve armazenar os registros contínuos de leitura do sensor em um banco de dados MySQL instalado em VMLinux. 
    * **RF04:** A plataforma web deve permitir o cadastro de novos usuários com os dados do produtor rural. 
    * **RF05:** A plataforma web deve permitir o login e autenticação de usuários previamente cadastrados para acesso à área restrita. 
    * **RF06:** O sistema deve fornecer um simulador financeiro acessível na área institucional para demonstrar a viabilidade econômica e a redução de perdas monetárias.
     * **RF07:** A plataforma deve exibir uma dashboard interativa contendo gráficos construídos com ChartJS. 
    * **RF08:** A dashboard deve renderizar os dados do sensor em tempo real para visualização do produtor. 
    * **RF09:** O sistema deve gerar alertas automáticos visuais imediatos na tela da dashboard para os produtores caso os níveis de fumaça ou gases captados ultrapassem os limites normais. 
    * **RF10:** O sistema deve permitir a geração de relatórios detalhados contendo o histórico das leituras de fumaça e gases captadas pelo sensor MQ-2. * 
    **RF11:** O usuário deve conseguir aplicar filtros de data e hora na dashboard para visualizar os dados de períodos específicos.
    * **RF12:** A plataforma deve registrar a data e a hora exatas de cada pico anormal de fumaça detectado para facilitar a auditoria do produtor. 
    * **RF13:** O sistema deve possuir uma funcionalidade para exportar os dados dos relatórios gerados para formatos de fácil leitura. 
    * **RF14:** A plataforma deve disparar notificações de alerta em formato de texto para os contatos cadastrados assim que o sistema identificar níveis críticos no canavial.
     * **RF15:** O sistema deve ter uma área de configurações onde o produtor rural possa adicionar ou atualizar os números de telefone e e-mails que receberão os alertas de risco
            
            diante desses requisitos funcionais e suas nomenclaturas  
            Gere conteúdos que contenham apenas dados sobre a empresa chamada 
            Canalytics, na qual utiliza sensores mq2 para monitorar e prever queimadas com o 
            método de modelagem de gaus para plumas de gás ou seja cálculo de perimetro para 
            identificar onde e quando o gás está muito acumulado e pode ocorrer um incêndio 
            com base em que o sensor já vai enviado soldado para o canavial e envie respostas 
            que ajudarão especialistas a resolver problemas relacionados à canalytics e seus 
            clientes e se não for uma pergunta relacionada envia uma mensagem 
            dizendo que não consegue resolver este problema: 
            ${mensagem}`

        });
        const resposta = (await modeloIA).text;
        const tokens = (await modeloIA).usageMetadata;

        console.log(resposta);
        console.log("Uso de Tokens:", tokens);

        return resposta;
    } catch (error) {
        console.error(error);
        throw error;
    }
}
