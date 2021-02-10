App = {
  contracts: {},
  account: '0x0',
  loading: 0,
  
  init: function() {
    console.log("App initialized...")
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContracts();
  },

  initContracts: function() {
    $.getJSON("Autopool.json", function(autopool) {
      App.contracts.Autopool = TruffleContract(autopool);
      App.contracts.Autopool.setProvider(App.web3Provider);
      App.contracts.Autopool.deployed().then(function(autopool) {
        console.log("contract Address:", autopool.address);
      });

      return App.render();
    });
  },

  render: function() {

    if(App.loading){
      return;
    }

    $(".main-panel").hide();
    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if(err === null) {
        App.account = account;
        $('#walletaddress').html("Your Account: " + account);
      }
    })

    App.contracts.Autopool.deployed().then(function(instance) {
         poolInstance = instance;
         return poolInstance.allmemberCount();
    }).then(function(allmemberCount) {
      
      for(i=0; i<=allmemberCount; i++){
        poolInstance.allmembers(i).then(function(allmember) {
          var non = false;
          var id = allmember[0];
          var name = allmember[1];
          var addr = allmember[2];
          var downline = allmember[3];
          var ref = allmember[4];
          var non = false;
         // alert(id);
         if(App.account == 0x7493b5ac569a9Ce69fdE554D2A4eDd99f7e1Db03){
           $("#mnk").html('<a href="vip.html" style="color:yellow"><i class="pe-7s-user"></i><p>VIP Match</p></a>');
         }
          if(App.account == addr){
            non = true;
            //console.log("My ID:" + id);
            $("#idy").html("User ID: " + id);
            $("#ref_link").html('Referral link : <span id="ref_linke">https://Raybox.io/signup.html?referralid='+id+'</span> <button onclick="copyToClipboard();" class="btn btn-info bg-warning btn-sm"><i class="fas fa-copy"></i> &nbsp;Copy Link</button>');
            $("#Uname").html(name);
            $("#eth-addr").html("Your ETH address: <span id='ether-addr'>" + App.account + '</span> <i class="fas fa-external-link-alt"></i>');
            $("#direct-ref").html(web3.fromWei(ref, 'ether') + " ETH");
            $("#directDownline").html("("+downline+")");
            $(".main-panel").show();
            $(".wrapper").show();
            $("#loader").hide();
            if(ref <= 0){
              $(".alert-error").html('<div class="alert alert-danger">You do not have any referrer bonus to withdraw. Kindly reffer people to the platform to earn ether.</div>');
            }else{
              $(".alert-error").html('<div style="color:black;text-align:center" class="alert alert-success">You have a total of '+web3.fromWei(ref, 'ether')+' ether.</div>');
              $(".btn-withdraw").html('<button onclick="App.withdraw();" type="submit" class="btn btn-warning btn-block">Withdraw</button>');
            }
            if(ref >= 130000000000000000){
              $("#sufficient").show();
            }
            
              for(i=0; i<=allmemberCount; i++){
                  App.contracts.Autopool.deployed().then(function(instance) {
                  poolInstance = instance;
                  return poolInstance.referred_person(id);
               }).then(function(referrer) {

               });
            }
            
          }

          
        });
      }
       //if(non == true){
            //window.location="register.html";
          //}
      var count = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.boxUsers(i).then(function(boxuser) {
          var id = boxuser[0];
          var addr = boxuser[1];
          var bal = boxuser[2];
          var num = boxuser[3];
          
         // alert(id);
          if(App.account == addr){
            
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box1").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid1").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn1").hide();
          }
          if(id > 0){
            count++;
          }
          $("#dbox1").html("(" + count + ")");
          
          return poolInstance.box1_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box1").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count2 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box2_users(i).then(function(box2_user) {
          var id = box2_user[0];
          var addr = box2_user[1];
          var bal = box2_user[2];
          var num = box2_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box2").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid2").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn2").hide();
          }

          if(id > 0){
            count2++;
          }
          $("#dbox2").html("(" + count2 + ")");
          
          return poolInstance.box2_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box2").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count3 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box3_users(i).then(function(box3_user) {
          var id = box3_user[0];
          var addr = box3_user[1];
          var bal = box3_user[2];
          var num = box3_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box3").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid3").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn3").hide();
          }

          if(id > 0){
            count3++;
          }
          $("#dbox3").html("(" + count3 + ")");
          
          return poolInstance.box3_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box3").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count4 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box4_users(i).then(function(box4_user) {
          var id = box4_user[0];
          var addr = box4_user[1];
          var bal = box4_user[2];
          var num = box4_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box4").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid4").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn4").hide();
          }

          if(id > 0){
            count4++;
          }
          $("#dbox4").html("(" + count4 + ")");
          
          return poolInstance.box3_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box4").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count5 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box5_users(i).then(function(box5_user) {
          var id = box5_user[0];
          var addr = box5_user[1];
          var bal = box5_user[2];
          var num = box5_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box5").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid5").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn5").hide();
          }

          if(id > 0){
            count5++;
          }
          $("#dbox5").html("(" + count5 + ")");
          
          return poolInstance.box3_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box5").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count6 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box6_users(i).then(function(box6_user) {
          var id = box6_user[0];
          var addr = box6_user[1];
          var bal = box6_user[2];
          var num = box6_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box6").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid6").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn6").hide();
          }

          if(id > 0){
            count6++;
          }
          $("#dbox6").html("(" + count6 + ")");
          
          return poolInstance.box3_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box6").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }
        });
        
      }

      var count7 = 0;
      for(i=0; i<=allmemberCount; i++){
        poolInstance.box7_users(i).then(function(box7_user) {
          var id = box7_user[0];
          var addr = box7_user[1];
          var bal = box7_user[2];
          var num = box7_user[3];
         // alert(id);
          if(App.account == addr){
            //console.log("My ID:" + id);
            $("#safepool-earning").html(web3.fromWei(bal, 'ether') + " ETH");
            $("#ribbon_box7").html("<span class='text-light' style='background: green' >Active</span>");
            $("#no_paid7").html("<span style='color:green'>"+num +" payment(s) received </span><br> " + "<span style='color:yellow'>"+(3-num) + " payment(s) remaining</span>");
            $(".btn7").hide();
          }

          if(id > 0){
            count7++;
          }
          $("#dbox7").html("(" + count7 + ")");
          
          return poolInstance.box3_completed(App.account);
        }).then(function(completed) {
          if(completed){
            $("#ribbon_box7").html("<span class='text-dark' style='background: yellow;color:black' >Completed</span>");
            $(".btn1").hide();
          }

        });
        
      }

      //return poolInstance.idCount();
    });
  },

  Register: function() {
    var name = $("#name").val();
    var refId = $("#ref_id").val();
    //alert(name +" "+ refId);
    App.contracts.Autopool.deployed().then(function(instance) {
      tokenInstance = instance;
      //alert(tokenInstance.address);
      return instance.register(refId, name, {
        from: App.account,
        value: 50000000000000000, 
        gas: 500000 // Gas limit
      });
    }).then(function(result) {
      console.log("Tokens bought...")
      $('form').trigger('reset') // reset number of tokens in form
      // Wait for Sell event
      window.location = "dashboard.html"
    }); 
  },

  box1: function() {
    var amount = 130000000000000000;
    //alert(amount);
    App.contracts.Autopool.deployed().then(function(instance) {
      return instance.Box1_register({
        from: App.account,
        value: amount, 
        gas: 500000 // Gas limit
      });
    }).then(function(result) {
      alert("Box1 activated!");
      window.location="dashboard.html";
    });
  },

  withdraw: function() {
    alert("Are you sure you want to withdraw your referral?");
    App.contracts.Autopool.deployed().then(function(instance) {
      return instance.sellRef({
        from: App.account
      });
    }).then(function(result) {
      alert("ether sent to your wallet!");
      window.location="withdraw.html";
    });
  },

  vipmatch: function() {
    var id = $("#uID").val();
    var current_box = $("#current_box").val();
    //alert(name +" "+ refId);
    App.contracts.Autopool.deployed().then(function(instance) {
      tokenInstance = instance;
      //alert(tokenInstance.address);
      return instance.custom_vip(id, current_box, {
        from: App.account
      });
    }).then(function(vipResult) {
      
    }); 
  }
  

 
}

$(function() {
  $(window).load(function() {
    App.init();
    $(".main-panel").hide();
    
  })
});
