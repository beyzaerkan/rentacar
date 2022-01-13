<template>
  <div class="container p-5">
    <h1>Admin Panel</h1>
    <div class="row">
      <div class="col-md-4">
        <div class="card" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Payments</h5>
            <h6 class="card-subtitle mb-2 text-muted">Total Payments</h6>
            <h2 class="card-text"><b>{{ totals.total_payment }} $</b> </h2>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">On Rent</h5>
            <h6 class="card-subtitle mb-2 text-muted">Count of Leased Cars</h6>
            <h2 class="card-text"><b>{{ totals.total_leased_cars }}</b> </h2>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card" style="width: 18rem;">
          <div class="card-body">
            <h5 class="card-title">Salaries</h5>
            <h6 class="card-subtitle mb-2 text-muted">Employees' total salaries</h6>
            <h2 class="card-text"><b>{{ totals.total_employee_salary }} $</b> </h2>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'AdminPanel',
  data() {
    return {
      totals: {},
    };
  },
  mounted() {
    axios.get('http://localhost:5000/totals', {
    }).then((res) => {
      this.totals = res.data;
      console.log(this.totals);
    });
  },
};
</script>
