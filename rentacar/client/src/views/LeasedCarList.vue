<template>
  <div>
    <div class="new">
    </div>
    <LeasedCarList />
  </div>
</template>

<script>
import LeasedCarList from '../components/LeasedCars/LeasedCarList.vue';
export default {
  name: 'LeasedListCar',
  components: {
    LeasedCarList,
  },
};
</script>

<style scoped>
</style>