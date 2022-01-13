const express = require("express");
const app = express();
const cors = require("cors");
const pool = require("./db");
var CronJob = require('cron').CronJob;


var job = new CronJob('0 0 * * * *', function() {
  pool.query("SELECT * FROM allLeasedCars() ")
});
job.start();

//middleware
app.use(cors());
app.use(express.json());

app.get("/", (req,res) =>{
  res.send("Success");
})

//ROUTES

//create a user
app.post("/register", async (req,res) => {
  try {
    const {first_name, last_name, mail, password, role_id} = req.body;
    const date = new Date();
    const newUser = await pool.query(
      "INSERT INTO users (first_name, last_name, mail, password, role_id, created_at, updated_at, deleted_at) VALUES($1, $2, $3, $4, $5, $6, $7, $8) RETURNING * ",
      [first_name, last_name, mail, password, role_id, date, date, date]
    );
    res.json(newUser.rows);
  } catch (error) {
    console.error(error.message);
  }
});

//login
app.post('/login', async(req, res) => {
  const { mail, password } = req.body;
  const user = await pool.query('SELECT * FROM users WHERE mail = $1 AND password = $2',
   [mail, password]
  );
  res.json(user.rows[0]);
	if (user.rowCount > 0) {
		res.send("Success")
	} else {
		res.send('Please enter Username and Password!');
		res.end();
	}
});

//create a car

app.post("/cars", async (req,res) => {
  try {
    const {price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id } = req.body;
    const date = new Date();
    const newCar = await pool.query(
      "INSERT INTO cars (price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING * ",
      [price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, date, date, date]
    );
    res.json(newCar.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});

//get all cars

app.get("/cars" , async(req,res) => {
  try {
    const allCars = await pool.query(
      "SELECT * FROM getCarsInfo(); ")
    res.json(allCars.rows);
  } catch (error) {
    console.error(error.message);
  }
});

//get a car

app.get("/cars/:id" , async(req,res) => {
  try {
    const { id } = req.params;
    const car = await pool.query(
      'SELECT * FROM getCarsInfo() WHERE car_id = $1',
     [id]
    );
    res.json(car.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});

//update a car

app.put("/cars/:id" , async(req,res) => {
  try {
    const { id } = req.params;
    const { price, image_url } = req.body;
    const updateCar = await pool.query(
      'UPDATE cars SET price = $1, image_url = $2  WHERE car_id = $3',
      [price, image_url, id] 
    );
    res.json(updateCar.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});


//delete a car

app.delete("/cars/:id" , async(req,res) => {
  try {
    const { id } = req.params;
    const deleteCar = await pool.query(
      'DELETE FROM cars WHERE car_id = $1 ',
      [id] 
    );
    res.json('Car was deleted!');
  } catch (error) {
    console.error(error.message);
  }
});


//araba kirala

app.post("/rent/:id", async (req,res) => {
  try {
    const { day, dealer_id, reception_date, delivery_date, user_id, rent_payment } = req.body;
    const { id } = req.params;
    const newRent = await pool.query(
      "INSERT INTO on_rent (day, reception_date, delivery_date, car_id, user_id, dealer_id, rent_payment) VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING * ",
      [day, reception_date, delivery_date, id, user_id, dealer_id, rent_payment]
    );
    res.json(newRent.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});


//kiralanan arabaları getir 
app.get("/rents" , async(req,res) => {
  try {
    const allCars = await pool.query(
      "SELECT * FROM getLeasedCarsInfo()")
    res.json(allCars.rows);
  } catch (error) {
    console.error(error.message);
  }
});


//markalar

app.get("/brands" , async(req,res) => {
  try {
    let brands = await pool.query(
      "SELECT * FROM getBrandsInfo() ");
    brands=brands.rows;
    let models = await pool.query('SELECT * FROM models');
    models= models.rows;
    brands.forEach(brand => {
    brand.models = models.filter( m => brand.brand_id === m.brand_id);
    });
    res.json(brands);
  } catch (error) {
    console.error(error.message);
  }
});

//totals

app.get("/totals" , async(req,res) => {
  try {
    const totals = await pool.query(
      "SELECT * FROM totals"
    );
    res.json(totals.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});

//çalışanlar

app.get("/employees" , async(req,res) => {
  try {
    const totals = await pool.query(
      "SELECT * FROM employees"
    );
    res.json(totals.rows);
  } catch (error) {
    console.error(error.message);
  }
});

//create a employee
app.post("/employees", async (req,res) => {
  try {
    const { first_name, last_name, email, phone_number, salary, dealer_id } = req.body;
    const date = req.body.date;
    const { hire_date } = new Date(date);
    const newEmployee = await pool.query(
      "INSERT INTO employees (first_name, last_name, email, phone_number, salary, dealer_id, hire_date) VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING * ",
      [first_name, last_name, email, phone_number, salary, dealer_id, hire_date]
    );
    res.json(newEmployee.rows[0]);
  } catch (error) {
    console.error(error.message);
  }
});


//get dealer

app.get("/cities" , async(req,res) => {
  try {
    let cities = await pool.query(
      "SELECT * FROM cities ");
      cities=cities.rows;
      let dealers = await pool.query('select * from dealers');
      dealers= dealers.rows;
      cities.forEach(city => {
      city.dealers = dealers.filter( m => city.city_id === m.city_id);
      });
    res.json(cities);
  } catch (error) {
    console.error(error.message);
  }
});




app.listen(5000, () => {
  console.log("Server has started on port 5000");
});
