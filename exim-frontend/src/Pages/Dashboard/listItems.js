import * as React from 'react';
import { useState } from 'react';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import DashboardIcon from '@mui/icons-material/Dashboard';
import CategoryIcon from '@mui/icons-material/Category';
import LocalShippingIcon from '@mui/icons-material/LocalShipping';
import AddIcon from '@mui/icons-material/Add';
import ExpandLess from '@mui/icons-material/ExpandLess';
import ExpandMore from '@mui/icons-material/ExpandMore';
import Collapse from '@mui/material/Collapse';
import List from '@mui/material/List';
import SettingsIcon from '@mui/icons-material/Settings';
import { Link } from 'react-router-dom';
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';


export function MainListItems() {

  const [openProducts, setOpenProducts] = useState(false);
  const [openDeliveries, setOpenDeliveries] = useState(false);


  const handleProductsClick = () => {
    setOpenProducts(!openProducts);
  };

  const handleDeliveriesClick = () => {
    setOpenDeliveries(!openDeliveries);
  };

  return (
    <React.Fragment>

        <Link to="/dashboard">
          <ListItemButton>
            <ListItemIcon>
              <DashboardIcon />
            </ListItemIcon>
            <ListItemText primary="Dashboard" />
          </ListItemButton>
        </Link>

        <ListItemButton onClick={handleProductsClick}>
          <ListItemIcon>
            <CategoryIcon />
          </ListItemIcon>
          <ListItemText primary="Products" />
          {openProducts ? <ExpandLess /> : <ExpandMore />}
        </ListItemButton>
        <Collapse in={openProducts} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>

            <Link to="/create-product">
              <ListItemButton>
                <ListItemIcon>
                  <AddIcon />
                </ListItemIcon>
                <ListItemText primary="Create Product" />
              </ListItemButton>
            </Link>

            <Link to="/update-product">
              <ListItemButton>
                <ListItemIcon>
                  <SettingsIcon />
                </ListItemIcon>
                <ListItemText primary="Update Product Status" />
              </ListItemButton>
            </Link>

            <Link to="/view-product">
              <ListItemButton>
                <ListItemIcon>
                  <RemoveRedEyeIcon />
                </ListItemIcon>
                <ListItemText primary="View Product" />
              </ListItemButton>
            </Link>

          </List>
        </Collapse>

      {/* <ListItemButton>
        <ListItemIcon>
          <LocalShippingIcon />
        </ListItemIcon>
        <ListItemText primary="Deliveries" />
      </ListItemButton> */}

      <ListItemButton onClick={handleDeliveriesClick}>
        <ListItemIcon>
          <LocalShippingIcon />
        </ListItemIcon>
        <ListItemText primary="Deliveries" />
        {openDeliveries ? <ExpandLess /> : <ExpandMore />}
      </ListItemButton>
      <Collapse in={openDeliveries} timeout="auto" unmountOnExit>
        <List component="div" disablePadding>

        <Link to="/create-delivery">
          <ListItemButton>
            <ListItemIcon>
              <AddIcon />
            </ListItemIcon>
            <ListItemText primary="Create Delivery" />
          </ListItemButton>
        </Link>

          <Link to="/update-delivery">
            <ListItemButton>
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText primary="Update Delivery Status" />
            </ListItemButton>
          </Link>

          <Link to="/update-transport">
            <ListItemButton>
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText primary="Update Transport" />
            </ListItemButton>
          </Link>

          <Link to="/update-shipment-date">
            <ListItemButton>
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText primary="Update Shipment" />
            </ListItemButton>
          </Link>

          <Link to="/update-delivery-date">
            <ListItemButton>
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText primary="Update Delivery" />
            </ListItemButton>
          </Link>

          <Link to="/update-location">
            <ListItemButton>
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText primary="Update Location" />
            </ListItemButton>
          </Link>

          <Link to="/view-delivery">
              <ListItemButton>
                <ListItemIcon>
                  <RemoveRedEyeIcon />
                </ListItemIcon>
                <ListItemText primary="View Product" />
              </ListItemButton>
          </Link>

        </List>
      </Collapse>

    </React.Fragment>
  );
}