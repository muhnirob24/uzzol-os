document.addEventListener('DOMContentLoaded', () => {
  const ctx = document.getElementById('deviceChart').getContext('2d');
  const data = {
    labels: ['CPU', 'RAM', 'Battery', 'Network'],
    datasets: [{
      label: 'Device Metrics',
      data: [60, 70, 85, 40],
      backgroundColor: ['#e91e63','#3f51b5','#00bcd4','#4caf50'],
      borderWidth: 1
    }]
  };
  const config = {
    type: 'bar',
    data,
    options: {
      scales: {
        y: { beginAtZero: true, max: 100 }
      }
    }
  };
  new Chart(ctx, config);
});
