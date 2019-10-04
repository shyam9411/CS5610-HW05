import React from 'react';
import ReactDOM from 'react-dom';

export default function game_init(root, channel) {
  ReactDOM.render(<MemoryGame channel={channel} />, root);
}

class MemoryGame extends React.Component {
	constructor(props) {
        super(props);
        this.channel = props.channel;

		this.state = {
			tiles: [],
			status: [],
			colors: [],
			score: 0,
			completed: false,
			clickOne: null,
			clickTwo: null
		};

		this.defaultState = this.state;
		this.timerId = null;

		this.handleClick = this.handleClick.bind(this);
		this.resetGame = this.resetGame.bind(this);
		this.channel.join()
		   .receive("ok", this.onJoin.bind(this))
           .receive("error", resp => { console.log("Unable to join", resp) });
	}

    onJoin({game}) {
        this.setState(game);
    }

    onUpdate({game}) {
		const arrIndices = game.colors.map((color, i) => color === "red" ? i : -1).filter((i) => i != -1)
		console.log(arrIndices);
		if (arrIndices.length > 0) {
			this.timerId = setTimeout(() => {
				this.timerId = null;
				this.channel.push("resetStateFor", {"game": this.state, "index1": arrIndices[0], "index2": arrIndices[1]})
				.receive("ok", this.onUpdate.bind(this));
			}, 2000)
		}
        this.setState(game);
    }

	/**
	 * Method to reset the game state to initial state. Also we randomise the tiles again as the game has been reset.
	 */
	resetGame() {
		this.channel.push("reset")
            .receive("ok", this.onUpdate.bind(this));	
	}

	/**
	 * Method to handle the click events on the DOM elements. We validate the click for a match if its corresponding match has been found by the user. Else the click would be considered as a new tile open.
	 * @param tileId determines the id of the tile from which the event was triggered
	 */
	handleClick(tileId) {
		if (this.state.status[parseInt(tileId)] || this.timerId != null)
			return;

        this.channel.push("guess", { "tileId": tileId, "game": this.state})
			.receive("ok", this.onUpdate.bind(this))
			.receive("completed", this.onUpdate.bind(this));
	}

	render() {
		let resetButton = <button className="reset" onClick={this.resetGame}>Reset Game</button>;
		let titleEle = <div className="titleContainer">Memory Game - Match the tiles</div>;
		let gameOver = <div className="doneText">Game Completed</div>;
			
		if (this.state.completed) { 
			return (<div className="doneRoot">
				{titleEle}
				{gameOver}
				{resetButton}
				<div className="score">Total Score: {this.state.score}</div> 
				</div>);
		}

		let gameTiles = [];
        for (let i = 0; i < 16; i++)
            gameTiles.push(<div className={"tiles " + this.state.colors[i]} id={this.state.tiles[i]} onClick={() => this.handleClick(i)}>{
				this.state.status[i] ? this.state.tiles[i] : ""}
				</div>);
		
		return (
			<div className="tileContainer">
				{titleEle}
				{gameTiles}
				{resetButton}
			</div>
		);
  	}
}

