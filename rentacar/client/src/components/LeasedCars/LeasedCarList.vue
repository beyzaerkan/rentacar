<template>
  <div class="p-5">
    <h1>Leased Car Listing</h1>
      <LeasedCarDetail :car="car" v-for="car in cars" :key="car.id"/>
  </div>
</template>
<script>
import axios from 'axios';
import LeasedCarDetail from './LeasedCarDetailSmall.vue';
export default {
  name: 'LeasedCarList',
  components: {
    LeasedCarDetail
  },
  data() {
    return {
      cars: [],
    };
  },
  mounted() {
    axios.get('http://localhost:5000/rents', {
    }).then((res) => {
      this.cars = res.data;
      console.log(res.data);
    });
  },
};
</script>