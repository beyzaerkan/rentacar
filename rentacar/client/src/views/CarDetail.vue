<template>
  <div class="container p-5">
    <div class="row">
      <div class="col-md-4">
        <img :src="car.image_url" :alt="car.model_id" class="img-fluid">
      </div>
      <div class="col-md-8">
        <h3>{{car.brand_name}}  {{car.model_name}}</h3>
        <h5> {{car.type}}</h5>
        <span>Fuel: {{car.fuel}}  Gear: {{car.gear}} Seat: {{car.seat}}</span>
        <p>{{car.price}} $ / per</p>
        <div v-if="isAdmin==='true'">
          <button type="button" class="btn btn-primary" @click="update()">Update</button>
        <button type="button" class="btn btn-danger" @click="deleteCar()">Delete</button>
        </div>
        <div v-else >
          <button type="button" class="btn btn-success" @click="rentCar()">Rent</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'axios';
export default {
  name: 'CarDetail',
  data() {
    return {
      car: [],
      isAdmin: false,
    };
  },
  
  mounted() {
    this.isAdmin= localStorage.getItem('isAdmin');
    axios.get(`http://localhost:5000/cars/${this.$route.params.id}`, {
    }).then((res) => {
      this.car = res.data;
    });
  },
  methods: {
    update(){
      this.$router.push(`/update-car/${this.car.car_id}`);
    },
    deleteCar(){
      axios.delete(`http://localhost:5000/cars/${this.$route.params.id}`, {
    }).then((res) => {
      if(res.status == 200){
        alert("Success");
        this.$router.push('/car-list');
      }
    });
    },
    rentCar(){
      this.$router.push(`/rent/${this.$route.params.id}`);
    }
  }
};
</script>
<style scoped>

</style>