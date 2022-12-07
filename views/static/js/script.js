var userOder = [];

function hide_all_elements(){
    document.getElementById('model').style.visibility = 'hidden';
}

function show_element(ele){
    ele.style.visibility = 'visible';
}

function demo_img_car(data){
    // console.log(url_id);
    // let data = json.split('&');
    // let id_component = data[0];
    let url_id = data;
    // userOder.push(id_component);
    document.getElementById('demo-img-car').setAttribute('src','http://drive.google.com/uc?export=view&id='+url_id);
}

function submit_order(){
    var http = new XMLHttpRequest();
    http.open("POST", '/build', true);
    http.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
    http.send("userOder=" + String(userOder));
}

function printOrderList(){
    console.log(userOder);
}