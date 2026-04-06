import 'dart:io';

void main(){
  var statusCodes = [100, 200, 301, 302, 999];
  for(var i =0; i<=statusCodes.length-1 ;i++){
    print(statusCodes[i]);
  }


/*
  var numCode = 100;

  switch(numCode){

    case''
  }
*/



  var command = 'OPEN';
  switch (command) {
    case 'CLOSED':
      executeClosed();
    case 'PENDING':
      executePending();
    case 'APPROVED':
      executeApproved();
    case 'DENIED':
      executeDenied();
    case 'OPEN':
      executeOpen();
    default:
      executeUnknown();
  }


}

