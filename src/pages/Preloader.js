import React from "react";
import "./Preloader.css"
import { PulseLoader } from "react-spinners";
import x from "../assets/cancel.png";
import refresh from "../assets/refresh (1).png";
import Button from "@mui/material/Button"

const handleSubmit = () => {
  window.location.reload(false);
};

export const PreLoader= ()=> {
  return (
    <div className="Preloader">
      <h1>
        <span style={{ marginRight: "10px" }}>
          Waiting for connection with wallet
        </span>
        <PulseLoader size="10" margin="5" />
      </h1>
    </div>
  );
}

export const FailedPreLoader=()=>{
    return (
        <div className="Preloader">
          <img className="fail-img" src={x} alt="" />
          <h1>
          Oops! 
          </h1>
            <h2>
             Wallet connection denied, reload the page to try again
            </h2>
            <Button type="submit" onClick={handleSubmit} variant="contained">
        <img className="refresh-img" src={refresh} alt="" />
        Refresh
      </Button>
        </div>
      );
}