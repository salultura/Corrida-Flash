import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.events.MouseEvent;
import flash.display.MovieClip;

/***Variáveis***/

//Controles
var velocidade:Number = 0;
var esquerda:Boolean;
var direita:Boolean;
var acelerador:Boolean;
var freio:Boolean;
var jogoParado:Boolean = false;
var distancia:Number = 0;
var timerInimigo:Timer = new Timer(1000);
var tempoDistancia:Timer = new Timer(1000);

//Visibilidade
perdeu_mc.visible = false;
venceu_mc.visible = false;
jogar_mc.visible = false;

//Container para inimigos
var adversarios:MovieClip = new MovieClip();
addChild(adversarios);


/***Eventos***/

stage.addEventListener(KeyboardEvent.KEY_DOWN, teclaPressionada);
stage.addEventListener(KeyboardEvent.KEY_UP, teclaLiberada);
jogador_mc.addEventListener(Event.ENTER_FRAME, moverJogador);
stage.addEventListener(Event.ENTER_FRAME, main);
timerInimigo.addEventListener(TimerEvent.TIMER, gerarInimigos);
jogar_mc.addEventListener(MouseEvent.MOUSE_DOWN, reiniciarJogo);
tempoDistancia.addEventListener(TimerEvent.TIMER, contaDistancia);

//Iniciando o Timer Event
timerInimigo.start();
tempoDistancia.start();


/***Funções***/

//Função principal do jogo
function main(e:Event):void{
	
	//Controle do cenário
	if(cenario_mc.y > 550){
		cenario_mc.y = 0;
	}
	
	//Condição de vitória
	if(distancia > 2){
		timerInimigo.reset();
		timerInimigo.stop();
		tempoDistancia.reset();
		tempoDistancia.stop();
		jogoParado == true;
		velocidade = 0;
		venceu_mc.visible = true;
		jogar_mc.visible = true;		
	}
	cenario_mc.y += velocidade * 2;
	painel_mc.velocidade_txt.text = int(velocidade * 10) + " KM/H";
	painel_mc.distancia_txt.text=distancia.toFixed(2) + " KM";
}

function reiniciarJogo(e:MouseEvent):void{
	
	if(adversarios.numChildren!=0){
		var i = adversarios.numChildren;
		while(i > 0){
			var ini=adversarios.getChildByName(adversarios.getChildAt(i-1).name);
			ini.removeEventListener(Event.ENTER_FRAME,controlarInimigo);
			adversarios.removeChildAt(i-1);
			i = adversarios.numChildren;
		}
	}
	
	perdeu_mc.visible = false;
	venceu_mc.visible = false;
	jogar_mc.visible = false;
	jogoParado = false;
	jogador_mc.x = 200;
	jogador_mc.y = 483;
	jogador_mc.addEventListener(Event.ENTER_FRAME, moverJogador);
	timerInimigo.start();
	distancia = 0;
}

//Crie e posiciona os inimigos no palco
function gerarInimigos(e:TimerEvent):void{
	var inimigo:Inimigo = new Inimigo();
	
	inimigo.y = 0;
	inimigo.x = (Math.random() * 200) + 100;
	
	inimigo.gotoAndStop(int (Math.random() * 3 + 1));
	
	adversarios.addChild(inimigo);
	
	//Posiciona o inimigo no segundo nível do palco (O stage é nível ZERO)
	setChildIndex(adversarios, 1);
	
	inimigo.addEventListener(Event.ENTER_FRAME, controlarInimigo);
}

//Exibe a distância percorrida
function contaDistancia(e:TimerEvent):void{
	distancia += (velocidade * 10) /60/60;
}

//Controla os inimigos no palco
function controlarInimigo(e:Event){
	
	if(jogoParado == false){
		e.target.y+= 5 + (velocidade * 2);
	}	
	
	if(e.target.y > 600){
		e.target.removeEventListener(Event.ENTER_FRAME, controlarInimigo);
		adversarios.removeChild(adversarios.getChildByName(e.target.name));
	}else{//Caso o carro inimigo colida com o jogador
		if(e.target.hitTestObject(jogador_mc)){
			timerInimigo.reset();
			timerInimigo.stop();
			jogoParado = true;
			velocidade = 0;
			jogador_mc.removeEventListener(Event.ENTER_FRAME, moverJogador);
			
			//Exibe os painéis
			perdeu_mc.visible = true;
			jogar_mc.visible = true;
			//trace("bateu");
		}
	}
}


//Controles
function teclaPressionada(e:KeyboardEvent):void{
	switch(e.keyCode){
		//Seta para esquerda
		case 37:
			esquerda = true;
			break;
		//Seta para cima
		case 38:
			acelerador = true;
			break;
		//Seta para direita
		case 39:
			direita = true;
			break;
		//Seta para baixo
		case 40:
			freio = true;
			break;
	}
}

function teclaLiberada(e:KeyboardEvent):void{
	switch(e.keyCode){
		//Seta para esquerda
		case 37:
			esquerda = false;
			break;
		//Seta para cima
		case 38:
			acelerador = false;
			break;
		//Seta para direita
		case 39:
			direita = false;
			break;
		//Seta para baixo
		case 40:
			freio = false;
			break;
	}
}

function moverJogador(e:Event):void{
	//Verifica o deslocamento no eixo X (Esquerda || Direita)
	if(esquerda == true && e.target.x > 110){
		e.target.x -= velocidade;
	}else if(direita == true && e.target.x < 290){
		e.target.x += velocidade;
	}
	
	//Verifica a aceleração e atualiza a variável
	if(acelerador == true && velocidade < 15){
		velocidade +=.25;
	}else if(freio == true && velocidade > 0){
		velocidade -=.25;
	}else if (acelerador == false && velocidade > 0){
		velocidade -= .5;
	}	
}