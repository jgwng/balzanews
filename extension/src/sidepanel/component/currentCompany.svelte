<script>
    export let title = '';
    export let onClick = () => {};
    
  </script>

  <div class="label">현재 신문사</div>
  <div class="title-container" on:click={onClick}>
    {title}
    <div class="down-icon" id="down">
        <img src="assets/images/down.svg" alt="Down Icon">
    </div>
  </div>
  
  <style>
    .title-container {
        background-color: var(--color-bg);
        position: relative;
        padding: 12px 0px;
        padding-left: 16px;
        padding-right: 12px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        text-align: left;
        margin-left: 8px;
        margin-right: 8px;
        border: 1px solid var(--color-border);
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.2s ease;
        color: var(--font-color);
        font-size: 16px;
    }

    .label {
      color: var(--font-color);
      font-size: 20px;
      margin-top: 12px;
      margin-bottom: 8px;
      margin-left: 8px;
      margin-right: 8px;
      text-align: left;
    }
    .down-icon {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 24px;
      height: 24px;
    }
  
    .down-icon img {
      width: 16px;
      height: 16px;
      display: block;
    }
    [data-theme="dark"] .down-icon img {
      filter: invert(1);
    }
  </style>