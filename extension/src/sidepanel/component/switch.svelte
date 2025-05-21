<script>
    let isLightMode = true;

    function toggleDarkMode() {
        isLightMode = !isLightMode;
        let dataTheme = isLightMode ? 'light' : 'dark';
        document.documentElement.setAttribute(
            'data-theme', 
            dataTheme
        );
        localStorage.setItem("theme", dataTheme);
    }   
</script>

<label class="switch">
    <span class="sun">
      <img src="../assets/images/light.svg" alt="Sun Icon">
    </span>
    <span class="moon">
      <img src="../assets/images/dark.svg" alt="Moon Icon">
    </span>   
    <input type="checkbox" class="input" on:click={toggleDarkMode} checked={isLightMode}>
    <span class="slider"></span>
</label>

<style>
    .switch {
        font-size: 17px;
        position: relative;
        display: inline-block;
        width: 60px;
        height: 30px;
    }

    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #3A3A3A;
        transition: .4s;
        border-radius: 30px;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 24px;
        width: 24px;
        border-radius: 20px;
        left: 3px;
        bottom: 3px;
        z-index: 2;
        background-color: #F2F2F2;
        transition: .4s;
    }

    .sun img {
        position: absolute;
        top: 5px;
        left: 32px;
        z-index: 1;
        width: 20px;
        height: 20px;
    }

    .moon img {
        position: absolute;
        top: 5px;
        left: 5px;
        z-index: 1;
        width: 20px;
        height: 20px;
    }

    .input:checked + .slider {
        background-color: #CECECE;
    }

    .input:focus + .slider {
        box-shadow: 0 0 1px #CECECE;
    }

.input:checked + .slider:before {
  transform: translateX(30px);
}
</style>