
import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';
import $ from 'jquery';


export default function init_todo(root) {
  ReactDOM.render(<Todo />, root);
}

class Todo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: [3, 4, 5],
    };
  }

  add5() {
    let xs = this.state.items.slice();
    xs.push(5);
    this.setState({
      items: xs,
    });
  }

  render() {
    let item_list = _.map(this.state.items, (item, ii) => {
      return <li key={ii}>{ii}: {item}</li>;
    });

    return (
      <div>
        <h2>Tasks</h2>
        <ul>
          {item_list}
        </ul>
        <button onClick={this.add5.bind(this)}>Add 5</button>
      </div>
    );
  }
}
