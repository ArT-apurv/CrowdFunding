import React from "react";
import Crowd from "./Crowd";
import {PreLoader,FailedPreLoader} from "./pages/Preloader";
const Web3 = require("web3");

const App = () => {
  const [walletConnected, setWalletConnected] = React.useState(false);
  const [instruction, setInstruction] = React.useState(
    "Waiting for connection with wallet..."
  );

  React.useEffect(() => {
    const connectWallet = async () => {
      if (!window.ethereum) return;

      try {
        await window.ethereum.send("eth_requestAccounts");
        window.Web3 = new Web3(window.ethereum);
      } catch (error) {
        setInstruction(
          "Wallet connection denied, reload the page to try again."
        );
        return;
      }

      setInstruction("");
      setWalletConnected(true);
    };
    connectWallet();
  }, []);
console.log(instruction)
  return (
    <div>
      {window.ethereum ? (
        walletConnected ? (
          <Crowd />
        ) : ((instruction==="Wallet connection denied, reload the page to try again."?
          <FailedPreLoader/>:<PreLoader/>)
        )
      ) : (
        "Metamask or any other compatible wallet not found."
      )}
    </div>
  );
};

export default App;
