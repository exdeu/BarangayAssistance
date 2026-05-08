<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InactivityTimeout.ascx.cs" Inherits="BarangayAssistance.InactivityTimeout" %>

<style>
    .inactivity-overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.45);
        z-index: 99999;
        align-items: center;
        justify-content: center;
        animation: fadeOverlay 0.3s ease;
    }

    .inactivity-popup {
        width: 360px;
        background: white;
        border-radius: 20px;
        padding: 30px;
        text-align: center;
        box-shadow: 0 20px 50px rgba(0,0,0,0.25);
        animation: popupIn 0.35s ease;
        font-family: 'Segoe UI', sans-serif;
    }

    .inactivity-popup h3 {
        color: #1a364e;
        margin-bottom: 12px;
        font-size: 1.4rem;
    }

    .inactivity-popup p {
        color: #5c6b7a;
        margin-bottom: 10px;
        line-height: 1.5;
    }

    .countdown-text {
        font-size: 2.4rem;
        font-weight: 800;
        color: #c0392b;
        margin: 18px 0;
    }

    .stay-btn {
        background: linear-gradient(135deg,#1a364e,#2980b9);
        color: white;
        border: none;
        border-radius: 50px;
        padding: 12px 24px;
        cursor: pointer;
        font-weight: 700;
        transition: all 0.3s ease;
    }

    .stay-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(0,0,0,0.2);
    }

    @keyframes popupIn {
        from {
            opacity: 0;
            transform: scale(0.9) translateY(20px);
        }
        to {
            opacity: 1;
            transform: scale(1) translateY(0);
        }
    }

    @keyframes fadeOverlay {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }
</style>

<div id="inactivityOverlay" class="inactivity-overlay">
    <div class="inactivity-popup">

        <h3>Session Timeout Warning</h3>

        <p>
            You have been inactive for one minute.
        </p>

        <p>
            You will be logged out in:
        </p>

        <div id="countdownText" class="countdown-text">
            3:00
        </div>

        <button type="button"
            class="stay-btn"
            onclick="stayLoggedIn()">
            Stay Logged In
        </button>

    </div>
</div>

<script>
    var inactivityTimer;
    var countdownTimer;
    var countdownSeconds = 60;
    var popupVisible = false;

    function resetInactivityTimer() {
        if (popupVisible) return;

        clearTimeout(inactivityTimer);

        inactivityTimer = setTimeout(function () {
            showInactivityPopup();
        }, 60000);
    }

    function showInactivityPopup() {
        if (popupVisible) return;

        popupVisible = true;
        countdownSeconds = 180;

        document.getElementById("inactivityOverlay").style.display = "flex";
        updateCountdownText();

        clearInterval(countdownTimer);

        countdownTimer = setInterval(function () {
            countdownSeconds--;
            updateCountdownText();

            if (countdownSeconds <= 0) {
                clearInterval(countdownTimer);
                window.location.href = "Logout.aspx";
            }
        }, 1000);
    }

    function updateCountdownText() {
        var minutes = Math.floor(countdownSeconds / 60);
        var seconds = countdownSeconds % 60;

        document.getElementById("countdownText").innerText =
            minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
    }

    function stayLoggedIn() {
        popupVisible = false;
        clearInterval(countdownTimer);

        document.getElementById("inactivityOverlay").style.display = "none";

        resetInactivityTimer();
    }

    document.addEventListener("DOMContentLoaded", resetInactivityTimer);
    document.addEventListener("mousemove", resetInactivityTimer);
    document.addEventListener("keydown", resetInactivityTimer);
    document.addEventListener("click", resetInactivityTimer);
    document.addEventListener("scroll", resetInactivityTimer);

    document.addEventListener("visibilitychange", function () {
        if (document.hidden) {
            clearTimeout(inactivityTimer);

            inactivityTimer = setTimeout(function () {
                showInactivityPopup();
            }, 60000);
        } else {
            resetInactivityTimer();
        }
    });
</script>