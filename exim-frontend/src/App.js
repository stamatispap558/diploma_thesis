import { Button, ConfigProvider, Space } from "antd";
import React from "react";
import { Routes, Route } from "react-router-dom";

import SignIn from "./Pages/Auth/SignIn";
import SignUp from "./Pages/Auth/SignUp";
import Dashboard from "./Pages/Dashboard/Dashboard";

const App = () => (
  <ConfigProvider
    theme={{
      token: {
        // Seed Token
        colorPrimary: "#00b96b",
        borderRadius: 2,

        // Alias Token
        colorBgContainer: "#f6ffed"
      }
    }}
  >
    <Routes>
      <Route path="/" element={<SignIn />} />
      <Route path="/signup" element={<SignUp />} />
      <Route path="/dashboard" element={<Dashboard />} />
    </Routes>
  </ConfigProvider>
);

export default App;
