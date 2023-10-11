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

        <Link to="/regulator-dashboard">
          <ListItemButton>
            <ListItemIcon>
              <DashboardIcon />
            </ListItemIcon>
            <ListItemText primary="Regulator Dashboard" />
          </ListItemButton>
        </Link>

        <ListItemButton onClick={handleProductsClick}>
          <ListItemIcon>
            <CategoryIcon />
          </ListItemIcon>
          <ListItemText primary="Inspect" />
          {openProducts ? <ExpandLess /> : <ExpandMore />}
        </ListItemButton>
        <Collapse in={openProducts} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>

            <Link to="/view-product-regulator">
              <ListItemButton>
                <ListItemIcon>
                  <RemoveRedEyeIcon />
                </ListItemIcon>
                <ListItemText primary="View Product" />
              </ListItemButton>
            </Link>

            <Link to="/view-delivery-regulator">
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

    </React.Fragment>
  );
}