// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.5.16;

contract Autopool {

     struct Downliners {
        uint256 id;
        address payable addr;
    } 

    //referrer mapping
    mapping(uint256 => mapping(uint256 => Downliners)) public referred_person;


    struct Allmembers {
        uint256 id;
        string name;
        address payable addr;
        uint256 direct_downliners;
        uint256 referrer_balance;
    }

    mapping(uint256 => Allmembers) public allmembers;
    uint256 public allmemberCount;

    struct Boxusers {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }

    mapping(uint256 => Boxusers) public boxUsers;
    uint256 public idCount;

    //define a mapping to store all the people who have completed box1
    mapping(address => bool) public box1_completed;
    mapping(address => bool) public box2_completed;
    mapping(address => bool) public box3_completed;
    mapping(address => bool) public box4_completed;
    mapping(address => bool) public box5_completed;
    mapping(address => bool) public box6_completed;
    mapping(address => bool) public box7_completed;

    struct Box2_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }

    mapping(uint256 => Box2_users) public box2_users;
    uint256 public idCount2;

    struct Box3_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }
    mapping(uint256 => Box3_users) public box3_users;
    uint256 public idCount3;

    struct Box4_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }
    mapping(uint256 => Box4_users) public box4_users;
    uint256 public idCount4;

    struct Box5_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }

    mapping(uint256 => Box5_users) public box5_users;
    uint256 public idCount5;

    struct Box6_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }
    mapping(uint256 => Box6_users) public box6_users;
    uint256 public idCount6;

    struct Box7_users {
        uint256 id;
        address payable addr;
        uint256 bal;
        uint paid;
        uint256 f_key;
    }
    mapping(uint256 => Box7_users) public box7_users;
    uint256 public idCount7;
    
    ////////VIP//////////
    
    uint256 public vipId_box1;
    uint256 public vipId_box2;
    uint256 public vipId_box3;
    uint256 public vipId_box4;
    uint256 public vipId_box5;
    uint256 public vipId_box6;
    uint256 public vipId_box7; 

    constructor () public {
        allmemberCount++;
        idCount++;
        allmembers[allmemberCount] = Allmembers(allmemberCount, 'Nation', msg.sender, 0, 0);
        boxUsers[idCount] = Boxusers(idCount, msg.sender, 0.13 ether, 1, allmemberCount);
    }

    function sellRef() public {
        for(uint i=0; i<=allmemberCount; i++){
            if(allmembers[i].addr == msg.sender){
                uint _grand = allmembers[i].referrer_balance;
                
                require(_grand>0, 'you do not have any referrer to sell');
                require(address(this).balance >= _grand, 'insufficient fund in the contract wallet');
                (msg.sender).transfer(_grand);
                allmembers[i].referrer_balance=0;
            }
        }
    }
    
    function sub()public{
        for(uint i=0; i<=allmemberCount; i++){
            if(allmembers[i].addr == msg.sender){
                uint _grand = allmembers[i].referrer_balance;
                for(uint z=0; z<=idCount; z++){
                   require(boxUsers[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount2; z++){
                   require(box2_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount3; z++){
                   require(box3_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount4; z++){
                   require(box4_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount5; z++){
                   require(box5_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount6; z++){
                   require(box6_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                for(uint z=0; z<=idCount7; z++){
                   require(box7_users[z].addr != msg.sender, 'You are already a member of this autopool');
                }
                require(_grand>=130000000000000000, 'you do not have enough referrer to activate box1');
                idCount++;
                boxUsers[idCount] = Boxusers(idCount, msg.sender, 0, 0, i);
                for(uint m=0; m<=idCount; m++){
          if(boxUsers[m].id > 0){
              address payable _recipient;
              _recipient = boxUsers[m].addr;
              
              if(boxUsers[m].paid == 2){
                   _recipient.transfer(130000000000000000); 
              }
              //amount of ether receeived by user
              boxUsers[m].bal += 130000000000000000;
              //increase that paid to this member
              boxUsers[m].paid++;

              if(boxUsers[m].paid == 3){
             //remove this member from this autopool and add him to the next

             Box2_register(boxUsers[m].addr);


             //shows that recipient has completed this autopool
             box1_completed[boxUsers[m].addr] = true;

             //delete this user from this autopool
             delete boxUsers[m];
              }


              break;

          }
      }
                if(_grand>130000000000000000){
                    allmembers[i].referrer_balance = _grand - 130000000000000000;
                }else{
                    allmembers[i].referrer_balance = 0;
                }
            }
        }
    }


    //register a new member
    function register(uint256 _referer, string memory _name) public payable {
        uint256 _amount = 50000000000000000;
        //make sure that user pays exactly 0.1 ether
        require(msg.value == _amount, 'You only need 5 ether to enter this autopool');
        
        //check if user has already registered
        for(uint i=0; i<=allmemberCount; i++){
            require(allmembers[i].addr != msg.sender, 'You are already registered');
        }

        //register this member
        allmemberCount++;
        allmembers[allmemberCount] = Allmembers(allmemberCount, _name, msg.sender, 0, 0);

        //store referrer information
        for(uint256 i=0; i<=allmemberCount; i++){
            if(allmembers[i].id == _referer){
                    allmembers[i].direct_downliners++;
                    allmembers[i].referrer_balance += _amount * 20/100;
                    referred_person[i][allmemberCount] = Downliners(allmemberCount, msg.sender);
                    allmembers[1].addr.transfer(_amount);
            }


        }

    }
    function custom_vip (uint _id, uint box) public {
        if(box==1){
            vip_match(_id); 
        }else if(box==2){
            vip_match2(_id);
        }else if(box==3){
            vip_match3(_id);
        }else if(box==4){
            vip_match4(_id);
        }
    }
    function vip_match (uint256 _id) public {
        require(vipId_box1 == 0, 'You have already placed a VIP on this box');
        //check if user has already registered on this box
        for(uint i=0; i<=idCount; i++){
            if(boxUsers[i].f_key == _id){
                vipId_box1 = _id; 
            }
        }
    }
    function vip_match2 (uint256 _id) public {
        require(vipId_box2 == 0, 'You have already placed a VIP on this box');
        //check if user has already registered on this box
        for(uint i=0; i<=idCount2; i++){
            if(box2_users[i].f_key == _id){
                vipId_box2 = _id;
            }
        }
    }
    function vip_match3 (uint256 _id) public {
        require(vipId_box3 == 0, 'You have already placed a VIP on this box');
        //check if user has already registered on this box
        for(uint i=0; i<=idCount3; i++){
            if(box3_users[i].f_key == _id){
                vipId_box3 = _id;
            }
        }
    }
    function vip_match4 (uint256 _id) public {
        require(vipId_box4 == 0, 'You have already placed a VIP on this box');
        //check if user has already registered on this box
        for(uint i=0; i<=idCount4; i++){
            if(box4_users[i].f_key == _id){
                vipId_box4 = _id;
            }
        }
    }

    function Box1_register() public payable {
        uint256 _amount = 130000000000000000;
        //make sure that user pays exactly 0.1 ether
        require(msg.value == _amount, 'You only need 5 ether to enter this autopool');
        //check if user has already registered on this box
        for(uint i=0; i<=idCount; i++){
            require(boxUsers[i].addr != msg.sender, 'You are already a member of this autopool');
        }

       // check if user has already completd this autopool
       require(box1_completed[msg.sender] == false, 'You have already completed this autopool');

        //increase user id
        idCount++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == msg.sender){
              //register this member
             boxUsers[idCount] = Boxusers(idCount, msg.sender, 0, 0, b);

          if(vipId_box1 > 0){
              
              if(boxUsers[vipId_box1].paid == 2){
                  address payable _recipient_addr = boxUsers[vipId_box1].addr;
                _recipient_addr.transfer(_amount); 
                
              }
               //amount of ether receeived by user
              boxUsers[vipId_box1].bal += msg.value;

              //increase that paid to this member
              boxUsers[vipId_box1].paid++;

              if(boxUsers[vipId_box1].paid == 3){
                  
             //OPEN NEXT BOX 
             Box2_register(boxUsers[vipId_box1].addr);

             //shows that recipient has completed this autopool
             box1_completed[boxUsers[vipId_box1].addr] = true;

             //delete this user from this autopool
             delete boxUsers[vipId_box1];
             
             vipId_box1 = 0;
              }
              

          }else{
              
////////////////////////////////////////////////////////////////

//send ether to the next member in the queue
      for(uint i=0; i<=idCount; i++){
          if(boxUsers[i].id > 0){
              address payable _recipient;
              _recipient = boxUsers[i].addr;
              
              if(boxUsers[i].paid == 2){
                   _recipient.transfer(_amount); 
              }
              //amount of ether receeived by user
              boxUsers[i].bal += msg.value;
              //increase that paid to this member
              boxUsers[i].paid++;

              if(boxUsers[i].paid == 3){
             //remove this member from this autopool and add him to the next

             Box2_register(boxUsers[i].addr);


             //shows that recipient has completed this autopool
             box1_completed[boxUsers[i].addr] = true;

             //delete this user from this autopool
             delete boxUsers[i];
              }


              break;

          }
      }

//////////////////////////////////////////////////////////////
}

   }
}



}

////////////////////////// BOX 2 STARTS HERE /////////////////////////////
function Box2_register(address payable _wallet) public {
        uint256 _amount = 260000000000000000;

       // check if user has already completd this autopool
       require(box2_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount2++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box2_users[idCount2] = Box2_users(idCount2, _wallet, 0, 0, b);

        if(vipId_box2 > 0){
              
              if(box2_users[vipId_box2].paid == 2){
                  address payable _recipient_addr = box2_users[vipId_box2].addr;
                _recipient_addr.transfer(_amount); 
                
              }
               //amount of ether receeived by user
              box2_users[vipId_box2].bal += _amount;

              //increase that paid to this member
              box2_users[vipId_box2].paid++;

              if(box2_users[vipId_box2].paid == 3){
                  
             //OPEN NEXT BOX 
             Box3_register(box2_users[vipId_box2].addr);

             //shows that recipient has completed this autopool
             box2_completed[box2_users[vipId_box2].addr] = true;

             //delete this user from this autopool
             delete box2_users[vipId_box2];
             
             vipId_box2 = 0;
              }
              

          }else{
               //send ether to the next member in the queue
      for(uint i=0; i<=idCount2; i++){
          if(box2_users[i].id > 0){

              address payable _recipient;
              _recipient = box2_users[i].addr;
              
              if(box2_users[i].paid == 2){
                  _recipient.transfer(_amount);
              }
              //amount of ether receeived by user
              box2_users[i].bal += _amount;

              //increase that paid to this member
              box2_users[i].paid++;

              if(box2_users[i].paid == 3){

             //remove this member from this autopool and add him to the next

             Box3_register(box2_users[i].addr);

             //shows that recipient has completed this autopool
             box2_completed[box2_users[i].addr] = true;

             //delete this user from this autopool
             delete box2_users[i];
              }


              break;

          }
      }
          }

   }
}


}

////////////////////////// BOX 3 STARTS HERE /////////////////////////////
function Box3_register(address payable _wallet) public {
        uint256 _amount = 520000000000000000;

       // check if user has already completd this autopool
       require(box3_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount3++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box3_users[idCount3] = Box3_users(idCount3, _wallet, 0, 0, b);
        if(vipId_box3 > 0){
              
              if(box3_users[vipId_box3].paid == 2){
                  address payable _recipient_addr = box3_users[vipId_box3].addr;
                _recipient_addr.transfer(_amount); 
              }
               //amount of ether receeived by user
              box3_users[vipId_box3].bal += _amount;

              //increase that paid to this member
              box3_users[vipId_box3].paid++;

              if(box3_users[vipId_box3].paid == 3){
                  
             //OPEN NEXT BOX 
             Box4_register(box3_users[vipId_box3].addr);

             //shows that recipient has completed this autopool
             box3_completed[box3_users[vipId_box3].addr] = true;

             //delete this user from this autopool
             delete box3_users[vipId_box3];
             
             vipId_box3 = 0;
              }
              
          }else{
              //send ether to the next member in the queue
      for(uint i=0; i<=idCount3; i++){
          if(box3_users[i].id > 0){

              address payable _recipient;
              _recipient = box3_users[i].addr;
             
              if(box3_users[i].paid == 2){
                   _recipient.transfer(_amount);
              }
              //amount of ether receeived by user
              box3_users[i].bal += _amount;

              //increase that paid to this member
              box3_users[i].paid++;

              if(box3_users[i].paid == 3){

             //remove this member from this autopool and add him to the next

             Box4_register(box3_users[i].addr);

             //shows that recipient has completed this autopool
             box3_completed[box3_users[i].addr] = true;

             //delete this user from this autopool
             delete box3_users[i];
              }


              break;

          }
      }
          }

   }
}


}

////////////////////////// BOX 4 STARTS HERE /////////////////////////////

function Box4_register(address payable _wallet) public {
        uint256 _amount = 1040000000000000000;

       // check if user has already completd this autopool
       require(box4_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount4++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box4_users[idCount4] = Box4_users(idCount4, _wallet, 0, 0, b);
         if(vipId_box4 > 0){
              
              if(box4_users[vipId_box4].paid == 2){
                  address payable _recipient_addr = box4_users[vipId_box4].addr;
                _recipient_addr.transfer(_amount); 
              }
               //amount of ether receeived by user
              box4_users[vipId_box4].bal += _amount;
              box4_users[vipId_box4].paid++;
              if(box4_users[vipId_box4].paid == 3){
             //OPEN NEXT BOX 
             Box5_register(box4_users[vipId_box4].addr);
             box4_completed[box4_users[vipId_box4].addr] = true;
             delete box4_users[vipId_box4];
             vipId_box4 = 0;
              }
              
          }else{
               //send ether to the next member in the queue
      for(uint i=0; i<=idCount4; i++){
          if(box4_users[i].id > 0){

              address payable _recipient;
              _recipient = box4_users[i].addr;
              
              if(box4_users[i].paid == 2){
                  _recipient.transfer(_amount);
              }
              //amount of ether receeived by user
              box4_users[i].bal += _amount;

              //increase that paid to this member
              box4_users[i].paid++;

              if(box4_users[i].paid == 3){

             //remove this member from this autopool and add him to the next

             Box5_register(box4_users[i].addr);
             //shows that recipient has completed this autopool
             box4_completed[box4_users[i].addr] = true;

             //delete this user from this autopool
             delete box4_users[i];
              }


              break;

          }
      }
          }

   }
}


}

////////////////////////// BOX 5 STARTS HERE /////////////////////////////

function Box5_register(address payable _wallet) public payable {
        uint256 _amount = 2080000000000000000;

       // check if user has already completd this autopool
       require(box5_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount5++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box5_users[idCount5] = Box5_users(idCount5, _wallet, 0, 0, b);


        //send ether to the next member in the queue
      for(uint i=0; i<=idCount5; i++){
          if(box5_users[i].id > 0){

              address payable _recipient;
              _recipient = box5_users[i].addr;
             
              if(box5_users[i].paid == 2){
                   _recipient.transfer(_amount);
              }
              //amount of ether receeived by user
              box5_users[i].bal += _amount;

              //increase that paid to this member
              box5_users[i].paid++;

              if(box5_users[i].paid == 3){

             //remove this member from this autopool and add him to the next

             Box6_register(box5_users[i].addr);

             //shows that recipient has completed this autopool
             box5_completed[box5_users[i].addr] = true;

             //delete this user from this autopool
             delete box5_users[i];
              }


              break;

          }
      }


   }
}



}

////////////////////////// BOX 6 STARTS HERE /////////////////////////////

function Box6_register(address payable _wallet) public payable {
        uint256 _amount = 4160000000000000000;

       // check if user has already completd this autopool
       require(box6_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount6++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box6_users[idCount6] = Box6_users(idCount6, _wallet, 0, 0, b);


        //send ether to the next member in the queue
      for(uint i=0; i<=idCount6; i++){
          if(box6_users[i].id > 0){

              address payable _recipient;
              _recipient = box6_users[i].addr;
             
              if(box6_users[i].paid == 2){
                  _recipient.transfer(_amount);
              }
              //amount of ether receeived by user
              box6_users[i].bal += _amount;

              //increase that paid to this member
              box6_users[i].paid++;

              if(box6_users[i].paid == 3){

             //remove this member from this autopool and add him to the next

             Box7_register(box6_users[i].addr);

             //shows that recipient has completed this autopool
             box6_completed[box6_users[i].addr] = true;

             //delete this user from this autopool
             delete box6_users[i];
              }


              break;

          }
      }


   }
}



        //box_users.push();
}

////////////////////////// BOX 7 STARTS HERE /////////////////////////////

function Box7_register(address payable _wallet) public payable {
        uint256 _amount = 8320000000000000000;

       // check if user has already completd this autopool
       require(box7_completed[_wallet] == false, 'You have already completed this autopool');

        //increase user id
        idCount7++;

      for(uint256 b=0; b<=allmemberCount; b++){
          if(allmembers[b].addr == _wallet){
              //register this member
             box7_users[idCount7] = Box7_users(idCount7, _wallet, 0, 0, b);


        //send ether to the next member in the queue
      for(uint i=0; i<=idCount7; i++){
          if(box7_users[i].id > 0){

              address payable _recipient;
              _recipient = box7_users[i].addr;
             
              if(box7_users[i].paid == 2){
                  _recipient.transfer(_amount * 3);
              }
              //amount of ether receeived by user
              box7_users[i].bal += _amount;

              //increase that paid to this member
              box7_users[i].paid++;

              if(box7_users[i].paid == 3){

             //remove this member from this autopool and add him to the next


             //shows that recipient has completed this autopool
             box7_completed[box7_users[i].addr] = true;

             //delete this user from this autopool
             delete box7_users[i];
              }


              break;

          }
      }


   }
}


}


   function addressBal() public view returns(uint256) {
       return address(this).balance;
   }
   function sendEther (address payable _wallet, uint256 _amount) public {
       _wallet.transfer(_amount);
   }
   function addref (uint _id, uint _amount) public {
       allmembers[_id].referrer_balance += _amount;
   }
}
