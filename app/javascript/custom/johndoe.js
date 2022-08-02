// function buttonClick(){
//   msg.innerText = 'お名前は' + nameText.value + 'さんですね';
// }

function inputChange(){
  msg.innerText = 'お名前は' + nameText.value + 'さんですね';
}

let nameText = document.getElementById('nameText');
nameText.value = '名前を入力する';
let msg = document.getElementById('msg');
nameText.addEventListener('change', inputChange);

// let checkButton = document.getElementById('checkButton');
// checkButton.addEventListener('click', buttonClick);

