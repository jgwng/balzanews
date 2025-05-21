<style>
    #loader-container {
        display: flex; 
        flex-grow: 1;
        width: 100%;
        height: calc(100vh - 220px);
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    .loader {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .bar {
        display: inline-block;
        width: 3px;
        height: 20px;
        background-color: rgba(0, 0, 0, .5);
        border-radius: 10px;
        animation: scale-up4 1s linear infinite;
    }

    .bar:nth-child(2) {
        height: 35px;
        margin: 0 5px;
        animation-delay: .25s;
    }

    .bar:nth-child(3) {
        animation-delay: .5s;
    }

    @keyframes scale-up4 {
        20% {
            background-color: #000000;
            transform: scaleY(1.5);
        }

        40% {
            transform: scaleY(1);
        }
    }

    .text {
        font-size: 16px;
        color: #333;
        padding-top: 10px;
    }

</style>


<div id="loader-container">
    <div class="loader">
        <div class="bar"></div>
        <div class="bar"></div>
        <div class="bar"></div>
    </div>
    <div class="text">기사를 찾고 있어요...</div>
</div>