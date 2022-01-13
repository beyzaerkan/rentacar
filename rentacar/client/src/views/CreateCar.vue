<template>
  <div class="container text-left py-3">
    <div class="row">
      <div class="col-md-10">
        <form @submit.prevent="createCar">
          <h2>Create a car</h2>
          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlSelect1">Car Brand</label>
                <select
                  v-model="brand_id"
                  class="form-control"
                  id="exampleFormControlSelect2"
                >
                  <option
                    v-for="brand in brands"
                    :key="brand.brand_id"
                    v-bind:value="brand.brand_id"
                  >
                    {{ brand.brand_name }}
                  </option>
                </select>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlSelect1">Car Model</label>
                <select
                  v-model="model_id"
                  class="form-control"
                  id="exampleFormControlSelect2"
                >
                  <option
                    v-for="model in brands.filter(
                      (b) => b.brand_id == brand_id
                    )[0].models"
                    :key="model.model_id"
                    v-bind:value="model.model_id"
                  >
                    {{ model.model_name }}
                  </option>
                </select>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1"> Fuel </label>
                <input class="form-control" type="text" v-model="fuel" />
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1"> Type </label>
                <input class="form-control" type="text" v-model="type" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1"> Gear </label>
                <input class="form-control" type="text" v-model="gear" />
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1"> Seat </label>
                <input class="form-control" type="text" v-model="seat" />
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="exampleFormControlTextarea1"> Price </label>
                <input class="form-control" type="text" v-model="price" />
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="url"
                  >Image Url
                  <small class="text-muted">
                    Please include http://</small
                  ></label
                >
                <input type="text" class="form-control" v-model="image_url" />
              </div>
            </div>
          </div>
          <br />

          <div class="row">
            <div class="col-md-12 text-right">
              <button type="reset" class="btn btn-link mx-2 reset">
                Reset
              </button>
              <button type="submit" class="btn btn-success submit">
                Submit
              </button>
            </div>
          </div>
        </form>
      </div>
      <div class="col-md-2 info">
        <h6>Information</h6>
        <ul>
          <li>Please enter the information completely and correctly.</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "CreateCar",
  data() {
    return {
      brands: [],
      brand_id: 1,
      model_id: "",
      dealer_id: 1,
      seat: "",
      gear: "",
      type: "",
      fuel: "",
      price: "",
      image_url: "",
      car: [],
    };
  },

  mounted() {
    axios.get("http://localhost:5000/brands", {}).then((res) => {
      this.brands = res.data;
    });
  },
  methods: {
    createCar() {
      axios
        .post("http://localhost:5000/cars", {
          brand_id: this.brand_id,
          model_id: this.model_id,
          dealer_id: this.dealer_id,
          seat: this.seat,
          gear: this.gear,
          type: this.type,
          fuel: this.fuel,
          price: this.price,
          image_url: this.image_url,
        })
        .then((response) => {
          if (response.status === 200) {
            this.car = response.data;
            this.$router.push(`/car-list/${this.car.car_id}`);
          }
        })
        .catch((err) => {
          if (err.response.status === 400) {
            alert("Failed! Please try again.");
          }
        });
    },
  },
};
</script>